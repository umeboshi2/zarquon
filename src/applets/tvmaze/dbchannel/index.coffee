import $ from 'jquery'
#import { Model, Collection } from 'backbone'
import Backbone from 'backbone'
import { LoveStore } from 'backbone.lovefield'
import PageableCollection from 'backbone.paginator'

import './local-tvshow'
import './local-tvshow-episode'

MainChannel = Backbone.Radio.channel 'global'
AppChannel = Backbone.Radio.channel 'tvmaze'

baseURL = "//api.tvmaze.com"

class SingleShow extends Backbone.Model
  url: ->
    name = @searchName
    "#{baseURL}/singlesearch/shows?q=#{name}"
  
AppChannel.reply 'single-show-search', (name) ->
  model = new SingleShow
  model.searchName = name
  return model

class ShowSearch extends Backbone.Collection
  url: -> "#{baseURL}/search/shows"

AppChannel.reply 'new-tv-show-search', (options) ->
  options = options or {}
  return new ShowSearch options

AppChannel.reply 'tv-show-search-collection', ->
  return ShowSearch
  
AppChannel.reply 'search-tv-shows', (query) ->
  collection = new ShowSearch
  return collection

  
class RemoteShow extends Backbone.Model
  urlRoot: ->
    "#{baseURL}/shows"

AppChannel.reply 'get-remote-show', (id) ->
  return new RemoteShow id: id

class RemoteEpisode extends Backbone.Model
  url: ->
    return @get('_links').self.href

class RemoteEpisodes extends Backbone.Collection
  model: RemoteEpisode
  url: ->
    "#{baseURL}/shows/#{@showId}/episodes"

AppChannel.reply 'get-remote-episodes', (id) ->
  collection = new RemoteEpisodes
  collection.showId = id
  return collection





