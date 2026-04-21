import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import vercel from "@astrojs/vercel";
import rehypeExternalLinks from "rehype-external-links";
import rehypeKatex from "rehype-katex";
import remarkMath from "remark-math";
import path from "path";

const daylight = {
  name: "daylight",
  type: "light",
  colors: {
    "editor.background": "#f5f5f5",
    "editor.foreground": "#1a1a1a",
  },
  tokenColors: [
    {
      scope: [
        "storage.type",
        "storage.modifier",
        "keyword.control",
        "keyword.operator.new",
      ],
      settings: { foreground: "#3b5bdb" },
    },
    {
      scope: [
        "string",
        "constant",
        "constant.numeric",
        "constant.language",
        "constant.character",
        "number",
      ],
      settings: { foreground: "#2d7f3e" },
    },
  ],
};

export default defineConfig({
  site: "https://barrettruth.com",
  output: "static",
  adapter: vercel(),
  build: {
    format: "file",
  },
  integrations: [
    mdx({
      remarkPlugins: [remarkMath],
      rehypePlugins: [
        rehypeKatex,
        [
          rehypeExternalLinks,
          {
            target: "_blank",
            rel: ["noopener", "noreferrer"],
          },
        ],
      ],
    }),
  ],
  vite: {
    resolve: {
      alias: {
        "@components": path.resolve(".", "src/components"),
      },
    },
  },
  markdown: {
    shikiConfig: {
      themes: {
        light: daylight,
      },
      langs: [],
      wrap: true,
    },
  },
});
