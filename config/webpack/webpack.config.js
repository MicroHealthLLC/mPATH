const path    = require("path")
const webpack = require("webpack")

// Extracts CSS into .css file
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// Removes exported JavaScript files from CSS-only entries
// in this example, entry.custom will create a corresponding empty custom.js file
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');
const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';
const { VueLoaderPlugin } = require('vue-loader')

module.exports = {
  mode,
  optimization: {
    moduleIds: 'deterministic'
  },
  devtool: "source-map",
  module: {
    rules: [
      {
        test: /\.vue(\.erb)?$/,
        use: [{
          loader: 'vue-loader'
        }]
      },
      {
        test: /\.(js)$/,
        exclude: /node_modules/,
        use: ['esbuild-loader'],
      },
      // {
      //   test: /\.(?:sa|sc|c)ss$/i,
      //   use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      // },
      {
        test: /\.(png|jpe?g|gif|eot|woff2|woff|ttf|svg)$/i,
        use: 'file-loader',
      },
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          'vue-style-loader',
          'sass-loader',
          'postcss-loader',
          {
            loader: 'css-loader',
            options: {
              // enable CSS Modules
              modules: true
            }
          }
        ]
      }
    ],
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.jsx', '.scss', '.css','.vue'],
    fallback: {
      path: require.resolve("path-browserify"),
      stream: require.resolve("stream-browserify"),
    },
    modules: [path.resolve(__dirname, '..', '..', 'app/javascript'), "node_modules"]
  },
  entry: {
    application: "./app/javascript/dashboard.js"
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds'),
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
    new VueLoaderPlugin()
  ]
}
