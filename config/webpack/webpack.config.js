const { webpackConfig, merge } = require('shakapacker')
const { VueLoaderPlugin } = require('vue-loader')
const webpack = require('webpack')
const dotenv = require('dotenv')

dotenv.config();

module.exports = merge({
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      },
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader', 'sass-loader'],
      }
    ]
  },
  plugins: [
    new VueLoaderPlugin(),
    new webpack.DefinePlugin({
      'process.env': JSON.stringify(process.env)
   })
  ],
  resolve: {
    extensions: ['.ts', '.tsx', '.vue', '.css'],
    alias: {
      vue: 'vue/dist/vue.esm'
    }
  }
}, webpackConfig)