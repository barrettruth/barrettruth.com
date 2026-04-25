default:
    @just --list

install:
    pnpm install --frozen-lockfile

run: install
    pnpm dev

build: install
    pnpm build

format: install
    pnpm biome check .

lint: install
    pnpm check

ci: format lint build
    @:
