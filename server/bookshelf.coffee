Knex = require 'knex'
Bookshelf = require 'bookshelf'
jsonColumns = require 'bookshelf-json-columns'
bsbcrypt = require 'bookshelf-bcrypt'



env = process.env.NODE_ENV or 'development'
config = require('../config')[env]

if config.database.client is 'pg'
  pg = require 'pg'
  pg.types.setTypeParser 20, 'text', parseInt

knex = Knex config.database
bookshelf = Bookshelf knex
bookshelf.plugin jsonColumns
bookshelf.plugin bsbcrypt

module.exports = bookshelf
