$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'

navigate_to_url = require('tbirds/util/navigate-to-url').default

ConfirmDeleteModal = require('./confirm-delete-modal').default
SearchFormView = require './search-show-view'
SearchResultsView = require './show-search-results'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'tvmaze'

mainText = require 'raw-loader!../index-doc.md'


itemTemplate = tc.renderable (model) ->
  itemBtn = '.btn.btn-sm'
  tc.li '.list-group-item', ->
    tc.span ->
      tc.a href:"#tvmaze/view/show/#{model.id}", model.content.name
    tc.span '.btn-group.pull-right', ->
      tc.button '.delete-item.btn.btn-sm.btn-danger.fa.fa-close', 'delete'
    
listTemplate = tc.renderable ->
  tc.div '.listview-header', ->
    tc.text "TV Shows"
  tc.ul ".list-group"


DefaultStaticDocumentTemplate = tc.renderable (post) ->
  tc.article '.document-view.content', ->
    tc.div '.body', ->
      #
      tc.h1 'TV Maze API Demo'
      tc.div '.search-form.listview-list-entry'
      tc.div '.search-results'
      tc.raw marked mainText
      
class MainView extends Marionette.View
  template: DefaultStaticDocumentTemplate
  templateContext:
    appName: 'tvmaze'
  ui:
    searchForm: '.search-form'
    searchResults: '.search-results'
  childViewEvents:
    'save:form:success': 'doSomething'
  doSomething: (model) ->
    rview = @getChildView 'searchResults'
    if not rview.ui.header.is ':visible'
      rview.ui.header.show()
    msg = "#{rview.collection.length}  results for \"#{model.get 'tvshow'}\""
    rview.triggerMethod 'set:header', msg
  regions:
    searchForm: '@ui.searchForm'
    searchResults: '@ui.searchResults'
  onRender: ->
    view = new SearchFormView
      collection: @collection
    @showChildView 'searchForm', view
    rview = new SearchResultsView
      collection: @collection
    @showChildView 'searchResults', rview

module.exports = MainView

