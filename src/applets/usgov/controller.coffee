import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import tc from 'teacup'
import ms from 'ms'

import ToolbarView from 'tbirds/views/button-toolbar'
import { MainController } from 'tbirds/controllers'
import { ToolbarAppletLayout } from 'tbirds/views/layout'
navigate_to_url = require 'tbirds/util/navigate-to-url'
scroll_top_fast = require 'tbirds/util/scroll-top-fast'

import './dbchannel'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'
AppChannel = Backbone.Radio.channel 'usgov'

class Controller extends MainController
  layoutClass: ToolbarAppletLayout
  view_index: ->
    @setupLayoutIfNeeded()
    # https://jsperf.com/bool-to-int-many
    completed = completed ^ 0
    require.ensure [], () =>
      View = require './views/index-view.coffee'
      collection  = AppChannel.request 'get-roles-collection'
      response = collection.fetch()
      response.done =>
        view = new View
          collection: collection
        @layout.showChildView 'content', view
      #@_loadView View, collection, 'role'
    # name the chunk
    , 'usgov-view-index'
      
export default Controller

