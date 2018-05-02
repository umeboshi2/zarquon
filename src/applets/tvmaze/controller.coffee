import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import tc from 'teacup'
import ms from 'ms'

import ToolbarView from 'tbirds/views/button-toolbar'
import { MainController } from 'tbirds/controllers'
import { ToolbarAppletLayout } from 'tbirds/views/layout'
import navigate_to_url from 'tbirds/util/navigate-to-url'
scroll_top_fast = require 'tbirds/util/scroll-top-fast'

import './dbchannel'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'
AppChannel = Backbone.Radio.channel 'tvmaze'


class Controller extends MainController
  layoutClass: ToolbarAppletLayout
  viewIndex: ->
    @setupLayoutIfNeeded()
    require.ensure [], () =>
      lcollection = AppChannel.request 'get-local-tvshows'
      Collection = AppChannel.request 'tv-show-search-collection'
      View = require './views/index-view'
      lcollection.fetch().then =>
        view = new View
          collection: new Collection
        @layout.showChildView 'content', view
    # name the chunk
    , 'tvmaze-view-index'

  viewShowList: ->
    return @viewShowListCards()
    
  viewShowListCards: ->
    @setupLayoutIfNeeded()
    collection = AppChannel.request 'get-local-tvshows'
    require.ensure [], () =>
      View = require './views/card-show-list'
      @_loadView View, collection, 'tvshow'
    # name the chunk
    , 'tvmaze-view-show-list-cards'
      
  viewShowListPackery: ->
    @setupLayoutIfNeeded()
    collection = AppChannel.request 'get-local-tvshows'
    require.ensure [], () =>
      View = require './views/packery-show-list'
      @_loadView View, collection, 'tvshow'
    # name the chunk
    , 'tvmaze-view-show-list-packery'
      
  viewShowListMasonry: ->
    @setupLayoutIfNeeded()
    collection = AppChannel.request 'get-local-tvshows'
    require.ensure [], () =>
      View = require './views/masonry-show-list'
      @_loadView View, collection, 'tvshow'
    # name the chunk
    , 'tvmaze-view-show-list-masonry'
      
  viewShowListFlat: ->
    @setupLayoutIfNeeded()
    collection = AppChannel.request 'get-local-tvshows'
    window.tvshows = collection
    require.ensure [], () =>
      View = require './views/flat-show-list'
      response = collection.fetch()
      response.done =>
        view = new View
          collection: collection
        @layout.showChildView 'content', view
    # name the chunk
    , 'tvmaze-view-show-list-flat'
      
  viewSearchShow: ->
    @setupLayoutIfNeeded()
    require.ensure [], () =>
      View = require './views/single-search-show-view'
      view = new View
      @layout.showChildView 'content', view
    # name the chunk
    , 'tvmaze-view-search-show'

  viewShow: (id) ->
    @setupLayoutIfNeeded()
    require.ensure [], () =>
      View = require './views/view-show'
      LModel = AppChannel.request 'get-local-tvshow-model'
      model = new LModel id: id
      @_loadView View, model, 'tvshow'
    # name the chunk
    , 'tvmaze-view-local-show'
    
  importSampleData: ->
    @setupLayoutIfNeeded()
    require.ensure [], () =>
      lcollection = AppChannel.request 'get-local-tvshows'
      Collection = AppChannel.request 'tv-show-search-collection'
      View = require './views/sample-data-import'
      lcollection.fetch().then =>
        view = new View
        @layout.showChildView 'content', view
    # name the chunk
    , 'tvmaze-import-sample-data'
    
  viewCalendar: ->
    @setupLayoutIfNeeded()
    require.ensure [], () =>
      lcollection = AppChannel.request 'get-local-tvshows'
      Collection = AppChannel.request 'tv-show-search-collection'
      View = require './views/calendar-view'
      lcollection.fetch().then =>
        view = new View
        @layout.showChildView 'content', view
    # name the chunk
    , 'tvmaze-view-calendar'
    
export default Controller

