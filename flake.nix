{
  description = "barrettruth.sh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      nixpkgs,
      systems,
      ...
    }:
    let
      forEachSystem =
        f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    in
    {
      formatter = forEachSystem (pkgs: pkgs.nixfmt-tree);

      packages = forEachSystem (pkgs: {
        default = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "barrettruth-com";
          version = "0.0.1";
          src = ./.;

          nativeBuildInputs = [
            pkgs.nodejs_22
            pkgs.pnpm_10
            pkgs.pnpmConfigHook
          ];

          pnpmDeps = pkgs.fetchPnpmDeps {
            inherit (finalAttrs) pname version src;
            fetcherVersion = 2;
            hash = "sha256-U6+QFRUUXc1aUpyd+r20gWviq67EGFXKCHaW12G+iDg=";
          };

          buildPhase = ''
            runHook preBuild
            pnpm build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            cp -r dist $out
            runHook postInstall
          '';
        });
      });

      devShells = forEachSystem (
        pkgs:
        let
          commonPackages = [
            pkgs.nodejs_22
            pkgs.openssh
            pkgs.pnpm
            pkgs.just
            pkgs.rsync
            pkgs.vtsls
          ];
        in
        {
          default = pkgs.mkShell { packages = commonPackages; };
          ci = pkgs.mkShell { packages = commonPackages; };
        }
      );
    };
}
