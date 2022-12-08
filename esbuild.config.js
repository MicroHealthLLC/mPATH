const glob = require("glob");
const esbuild = require("esbuild");
const vuePlugin = require("esbuild-vue");
const { nodeExternalsPlugin } = require('esbuild-node-externals');

// const {lessLoader} = require("esbuild-plugin-less");
const isProduction = ["production", "staging"].includes(
  process.env.WEBPACK_ENV
);
const fs = require("fs");
const path = require('path')

console.log("******", path.join(process.cwd(), "app/javascript"))

const config = {
  // entryPoints: glob.sync("app/javascript/packs/*.js"),
  entryPoints: ["app/javascript/packs/dashboard.js"],
  bundle: true,
  assetNames: "[name]-[hash].digested",
  chunkNames: "[name]-[hash].digested",
  logLevel: "info",
  outdir: "app/assets/builds",
  publicPath: `${process.env.CDN_HOST ?? ""}/assets`,
  absWorkingDir: path.join(process.cwd()),
  plugins: [
    vuePlugin({
      extractCss: true,
      workers: false,
      onReadFile: path => {
        console.error("The following dependency was used:", path);
      }
    }),
    nodeExternalsPlugin()
  ],
  tsconfig: "tsconfig.json",
  format: "esm",
  splitting: true,
  // inject: ["./react-shim.js"],
  mainFields: ["browser", "module", "main"],
  loader: {
    ".locale.json": "file",
    ".json": "json",
    ".png": "file",
    ".jpeg": "file",
    ".jpg": "file",
    ".svg": "file"
  },
  define: {
    global: "window",
    RAILS_ENV: JSON.stringify(process.env.RAILS_ENV || "development"),
    VERSION: JSON.stringify(process.env.IMAGE_TAG || "beta"),
    COMMITHASH: JSON.stringify(process.env.GIT_COMMIT || ""),
  },
  incremental: process.argv.includes("--watch"),
  sourcemap: true,
  minify: isProduction,
  metafile: true,
  target: ["safari12", "ios12", "chrome92", "firefox88"],
};

if (process.argv.includes("--watch")) {
  (async () => {
    const result = await esbuild.build(config);
    chokidar.watch("./app/javascript/**/*.js").on("all", async (event, path) => {
      if (event === "change") {
        console.log(`[esbuild] Rebuilding ${path}`);
        console.time("[esbuild] Done");
        await result.rebuild();
        console.timeEnd("[esbuild] Done");
      }
    });
  })();
} else {
  // (async () => {
  //   const result = await esbuild.build(config);
  //   fs.writeFileSync(
  //     path.join(__dirname, "metafile.json"),
  //     JSON.stringify(result.metafile)
  //   );
  // })

  esbuild.build(config); 

}
