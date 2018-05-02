$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'

navigate_to_url = require('tbirds/util/navigate-to-url').default
PaginateBar = require('tbirds/views/paginate-bar').default

ConfirmDeleteModal = require('./confirm-delete-modal').default

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'




itemTemplate = tc.renderable (model) ->
  itemBtn = '.btn.btn-sm'
  tc.li '.list-group-item', ->
    tc.span ->
      tc.a href:"#tvmaze/view/show/#{model.id}", model.content.name
    tc.span '.btn-group.pull-right', ->
      tc.button '.delete-item.btn.btn-sm.btn-danger.fa.fa-close',
      style:'display:none', 'delete'
    
listTemplate = tc.renderable (model) ->
  console.log "listTemplate", model
  totalPages = model.collection.state.totalPages
  firstPage = model.collection.state.firstPage
  lastPage = model.collection.state.lastPage
  tc.div '.listview-header', ->
    tc.text "TV Shows"
  tc.nav '.paginate-bar'
  tc.ul ".list-group"


class ItemView extends Marionette.View
  template: itemTemplate
  ui:
    item: '.list-group-item'
    link: 'a'
    deleteItem: '.delete-item'
  events:
    'click @ui.link': 'showRole'
    'click @ui.deleteItem': 'deleteItem'
  showRole: (event) ->
    event.preventDefault()
    navigate_to_url "#tvmaze/shows/view/#{@model.id}"
  _show_modal: (view, backdrop) ->
    app = MainChannel.request 'main:app:object'
    layout = app.getView()
    modal_region = layout.getRegion 'modal'
    modal_region.backdrop = backdrop
    modal_region.show view
  deleteItem: ->
    view = new ConfirmDeleteModal
      model: @model
    @_show_modal view, true
    
class ItemCollectionView extends Marionette.CollectionView
  childView: ItemView

class ListView extends Marionette.View
  template: listTemplate
  templateContext: ->
    collection: @collection
  ui:
    header: '.listview-header'
    paginateBar: '.paginate-bar'
    itemList: '.list-group'
  regions:
    paginateBar: '@ui.paginateBar'
    itemList: '@ui.itemList'
  onRender: ->
    view = new ItemCollectionView
      collection: @collection
    @showChildView 'itemList', view
    view = new PaginateBar
      collection: @collection
    @showChildView 'paginateBar', view
    
view_template = tc.renderable (model) ->
  tc.div '.row.listview-list-entry', ->
    tc.raw marked "# #{model.appName} started."
    
class MainView extends Marionette.View
  template: view_template
  templateContext:
    appName: 'tvmaze'
    
module.exports = ListView

