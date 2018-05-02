path = require 'path'
jwtAuth = require 'express-jwt'

mpath = path.resolve __dirname, '..', 'models'
BSapi = require('bookshelf-csapi')

#Promise = require 'bluebird'

env = process.env.NODE_ENV or 'development'
config = require('../../config')[env]

APIPATH = config.apipath

# model routes
basicmodel = require './basicmodel'
misc = require './miscstuff'
bookroutes = require './bookroutes'

setup = (app) ->
  config = app.locals.config
  jwtOptions = config.jwtOptions
  authOpts = secret: jwtOptions.secret
  bsapi = BSapi
    models: app.locals.bsmodels
  app.use "#{APIPATH}/bapi", jwtAuth authOpts
  app.use "#{APIPATH}/bapi", bsapi

  app.use "#{APIPATH}/booky", jwtAuth authOpts
  app.use "#{APIPATH}/booky", bookroutes

  app.use "#{APIPATH}/misc", jwtAuth authOpts
  app.use "#{APIPATH}/misc", misc
  
module.exports =
  setup: setup
  
