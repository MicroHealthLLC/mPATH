const path    = require("path")
const webpack = require("webpack")

// Extracts CSS into .css file
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// Removes exported JavaScript files from CSS-only entries
// in this example, entry.custom will create a corresponding empty custom.js file
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');

const { VueLoaderPlugin } = require('vue-loader')

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';

module.exports = {
  mode,
  devtool: "source-map",
  entry: {
    dashboard: "./app/javascript/packs/dashboard.js"
  },
  module: {
    rules: [

        { 
          test: /\.vue$/,
          loader: 'vue-loader'
        },
        {
          test: /\.(?:sa|sc|c)ss$/i,
          use: ['style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
        },
        {
          exclude: /\.(s?(a?|c)ss|js|html)$/,
          test: /\.(png|jpe?g|gif|eot|woff2|woff|ttf|svg)$/i,
          use: 'file-loader'
        }
    ]
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds'),
  },
  resolve: {
    alias: {
      vue$: "vue/dist/vue.runtime.esm.js"
    },
    extensions: ["*", ".js", ".vue", ".json", '.scss', '.css', '.jsx']
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
    new VueLoaderPlugin(),
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
  ],
  optimization: {
    moduleIds: 'deterministic'
  }
}
