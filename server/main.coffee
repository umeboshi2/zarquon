os = require 'os'
path = require 'path'
http = require 'http'

express = require 'express'
gzipStatic = require 'connect-gzip-static'

# Set the default environment to be `development`
process.env.NODE_ENV = process.env.NODE_ENV || 'development'

env = process.env.NODE_ENV or 'development'
config = require('../config')[env]


Middleware = require './middleware'
UserAuth = require './userauth'


UseMiddleware = false or process.env.__DEV_MIDDLEWARE__ is 'true'
PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or 'localhost'
#HOST = process.env.NODE_IP or '0.0.0.0'

# create express app
app = express()

app.locals.config = config

Middleware.setup app
UserAuth.setup app

app.use '/assets', express.static(path.join __dirname, '../assets')

if UseMiddleware
  #require 'coffee-script/register'
  webpack = require 'webpack'
  middleware = require 'webpack-dev-middleware'
  config = require '../webpack.config'
  compiler = webpack config
  app.use middleware compiler,
    #publicPath: config.output.publicPath
    # FIXME using abosule path?
    publicPath: '/build/'
    stats:
      colors: true
      modules: false
      chunks: true
      #reasons: true
      maxModules: 9999
  console.log "Using webpack middleware"
else
  app.use '/dist', gzipStatic(path.join __dirname, '../dist')

# serve thumbnails
if process.env.NODE_ENV == 'development'
  thumbsdir = path.join __dirname, '../thumbs'
else
  thumbsdir = "#{process.env.OPENSHIFT_DATA_DIR}thumbs"
app.use '/thumbs', express.static(thumbsdir)
  
#app.get '/', pages.make_page 'index'
#app.use '/', (req, res, next) ->
#  return res.redirect 307, 'dist/'

app.use '/', express.static(path.join __dirname, '../dist')

server = http.createServer app
serving_msg = "#{config.brand} server running on #{HOST}:#{PORT}."

server.listen PORT, HOST, ->
  console.log serving_msg

module.exports =
  app: app
  
