import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import tc from 'teacup'
import ms from 'ms'

import ToolbarView from 'tbirds/views/button-toolbar'
import { MainController } from 'tbirds/controllers'
import { ToolbarAppletLayout } from 'tbirds/views/layout'
navigate_to_url = require 'tbirds/util/navigate-to-url'
import scroll_top_fast from 'tbirds/util/scroll-top-fast'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'
ResourceChannel = Backbone.Radio.channel 'resources'
AppChannel = Backbone.Radio.channel 'todos'

toolbarEntries = []

toolbarEntryCollection = new Backbone.Collection toolbarEntries
AppChannel.reply 'get-toolbar-entries', ->
  toolbarEntryCollection

class Controller extends MainController
  layoutClass: ToolbarAppletLayout
  setupLayoutIfNeeded: ->
    super()
    toolbar = new ToolbarView
      collection: toolbarEntryCollection
    @layout.showChildView 'toolbar', toolbar
    return
    
  start: ->
    @viewIndex()
    return
    
  _viewResource: (doc) ->
    require.ensure [], () =>
      View = require './views/index-view'
      view = new View
        model: doc
      @layout.showChildView 'content', view
      scroll_top_fast()
    # name the chunk
    , 'frontdoor-view-page'
    
  viewPage: (name) ->
    @setupLayoutIfNeeded()
    doc = DocChannel.request 'get-document', name
    response = doc.fetch()
    response.done =>
      @_viewResource doc
      return
    response.fail ->
      MessageChannel.request 'danger', 'Failed to get document'
      return
    return
    
  view_index: ->
    @setupLayoutIfNeeded()
    # https://jsperf.com/bool-to-int-many
    completed = completed ^ 0
  viewIndex: ->
    #@setupLayoutIfNeeded()
    @viewPage 'intro'
    return

  themeSwitcher: ->
    @setupLayoutIfNeeded()
    require.ensure [], () =>
      View = require './views/theme-switch'
      view = new View
      @layout.showChildView 'content', view
      scroll_top_fast()
    # name the chunk
    , 'frontdoor-view-switch-theme'
    
  viewDbAdmin: ->
    @setupLayoutIfNeeded()
    require.ensure [], () =>
      View = require './views/idbview'
      view = new View
      @layout.showChildView 'content', view
    # name the chunk
    , 'frontdoor-view-dbadmin'
    
    
    
export default Controller

