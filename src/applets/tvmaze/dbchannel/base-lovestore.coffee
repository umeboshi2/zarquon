import { result } from 'underscore'
import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import { LoveStore } from 'backbone.lovefield'

MainChannel = Backbone.Radio.channel 'global'
AppChannel = Backbone.Radio.channel 'tvmaze'

dbConn = MainChannel.request 'main:app:dbConn', 'tvmaze'

class BaseModel extends Backbone.Model
  toJSON: ->
    data = {}
    fields = @getOption 'fields'
    fields.forEach (field) =>
      data[field] = @get field
    return data
    
class DbInterface extends Marionette.Object
  channelName: 'tvmaze'
  # FIXME use _.once
  loveStore: ->
    executed = false
    if not executed
      executed = true
      tableName = @getOption 'tableName'
      if not tableName
        throw new Error "need a table name"
      return new LoveStore dbConn, tableName
    return
  initialize: (options) ->
    
  newModel: (options) ->
    options = options or {}
    options.loveStore = options.loveStore or @loveStore
    model = new BaseModel options

TvShowStore = new LoveStore dbConn, 'TVMazeShow'

showFields = [ 'id', 'name', 'url', 'self', 'premiered',
  'runtime', 'network_name', 'imdb', 'status', 'summary',
  'img_med', 'img_orig', 'content'
  ]
class LocalTvShow extends Backbone.Model
  loveStore: TvShowStore
  toJSON: ->
    data = {}
    showFields.forEach (field) =>
      data[field] = @get field
    return data
    
class LocalTvShowCollection extends Backbone.Collection
  loveStore: TvShowStore
  model: LocalTvShow

local_shows = new LocalTvShowCollection
AppChannel.reply 'get-local-tvshows', ->
  return local_shows
AppChannel.reply 'get-local-tvshow-model', ->
  return LocalTvShow
AppChannel.reply 'get-local-tvshow-collection', ->
  return LocalTvShowCollection

AppChannel.reply 'save-local-show', (data) ->
  model = new LocalTvShow
    id: data.id
    name: data.name
    url: data.url
    self: data._links.self.href
    premiered: new Date data.premiered
    runtime: data.runtime
    network_name: data?.network?.name or 'NO NETWORK'
    imdb: data.externals.imdb
    status: data.status
    summary: data.summary
    img_med: data.image?.medium
    img_orig: data.image?.original
    content: data
  renewed = true
  model.isNew = ->
    if renewed
      renewed = false
      return true
    return false
  local_shows.add model
  p = model.save()
  return p


