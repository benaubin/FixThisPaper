webpack = require 'webpack'

urlLoader = (extension, name = '[name]', directory) ->
  extension = if extension then ".#{extension}" else ""
  directory = if directory then "#{directory}/" else ""
  "url?hash=sha512&limit=5000&digest=hex&name=#{directory}#{name}-[hash].[ext]#{extension}"

# must match config.webpack.dev_server.port
devServerPort = 3808
# set NODE_ENV=production on the environment to add asset fingerprints
production = process.env.NODE_ENV == 'production'
config =
  entry: application: './src/main.coffee'
  output:
    path: 'build'
    publicPath: '/build/'
    filename: 'main.js'
  resolve:
    extensions: [
      '', '.slim', '.slm', '.coffee', '.ts', '.js.ts', '.tsx', '.js', '.jsx', '.html', '.component.coffee'
    ]
  module:
    preLoaders: [
      {
        test: /\.(jpe?g|png|gif|svg)$/i
        loader: 'img'
      }
      { test: /\.md$/, loader: "markdown" }
      { test: /\.sli?m$/, loaders: ['slm'] }
      { test: /\.yaml/, loader: "yaml" }
      { test: /\.cson/, loaders: ["cson?file", "extricate", "interpolate?prefix={[{&suffix=}]}"] }
    ]
    loaders: [
      { test: /\.coffee/, loader: "coffee" }
      { test: /\.md$/, loader: "html?interpolate" }
      { test: /\.sli?m$/, loader: 'html?interpolate' }
      {
        test: /\.(jpe?g|png|gif|svg)$/i
        loader: urlLoader(false, undefined, 'img')
      }
      { test: /\.([jc]son|yaml)$/, loader: "json" }
      { test: /\.txt$/, loader: 'raw' }
    ]
    postLoaders: []
  plugins: []
if production
  config.plugins.push new (webpack.NoErrorsPlugin), new (webpack.optimize.UglifyJsPlugin)(
    compressor: warnings: false
    sourceMap: false), new (webpack.DefinePlugin)('process.env': NODE_ENV: JSON.stringify('production')), new (webpack.optimize.DedupePlugin), new (webpack.optimize.OccurenceOrderPlugin)
else
  config.module.postLoaders.push(
    test: /\.component/,
    loader: 'react-hot'
  )
  config.plugins.push new webpack.HotModuleReplacementPlugin()
  config.devServer =
    port: devServerPort
    headers:
      'Access-Control-Allow-Origin': '*'
    inline: true
    hot: true
module.exports = config
