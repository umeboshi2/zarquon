import Backbone from 'backbone'
import { LoveStore } from 'backbone.lovefield'

MainChannel = Backbone.Radio.channel 'global'
AppChannel = Backbone.Radio.channel 'tvmaze'

dbConn = MainChannel.request 'main:app:dbConn', 'tvmaze'

TvEpisodeStore = new LoveStore dbConn, 'TVMazeEpisode'

episodeFields = [ 'id', 'show_id', 'name', 'url', 'self', 'season',
  'number', 'airdate', 'airtime', 'runtime', 'summary', 'img_med',
  'img_orig', 'content'
  ]
class LocalTvEpisode extends Backbone.Model
  loveStore: TvEpisodeStore
  toJSON: ->
    data = {}
    episodeFields.forEach (field) =>
      data[field] = @get field
    return data

class LocalTvEpisodeCollection extends Backbone.Collection
  loveStore: TvEpisodeStore
  model: LocalTvEpisode
  
local_episodes = new LocalTvEpisodeCollection
AppChannel.reply 'get-local-episodes', ->
  return local_episodes
AppChannel.reply 'get-local-episode-model', ->
  return LocalTvEpisode
AppChannel.reply 'get-local-episode-collection', ->
  return LocalTvEpisodeCollection

# data is id, show_id, content
AppChannel.reply 'save-local-episode', (data) ->
  model = new LocalTvEpisode
    id: data.id
    show_id: data.show_id
    name: data.content.name
    url: data.content.url
    self: data.content._links?.self.href
    season: data.content.season
    number: data.content.number
    airdate: new Date data.content.airdate
    airtime: data.content.airtime
    runtime: data.content?.runtime or ''
    summary: data.content?.summary or ''
    img_med: data.content?.image?.medium or ''
    img_orig: data.content?.image?.original or ''
    content: data.content
  renewed = true
  model.isNew = ->
    if renewed
      renewed = false
      return true
    return false
  local_episodes.add model
  p = model.save()
  return p



