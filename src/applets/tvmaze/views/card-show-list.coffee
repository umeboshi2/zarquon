$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'

noImage = require('tbirds/templates/no-image-span').default
PaginateBar = require('tbirds/views/paginate-bar').default

navigate_to_url = require('tbirds/util/navigate-to-url').default

ConfirmDeleteModal = require('./confirm-delete-modal').default
itemTemplate = require './templates/tvshow-item'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

listContainer = '.show-list'

listTemplate = tc.renderable ->
  tc.div '.listview-header', ->
    tc.text "TV Shows"
  tc.nav '.paginate-bar'
  tc.button '.flat-list.btn.btn-info', "Show flat list"
  tc.div listContainer


divStyle = 'width:20%;border-style:solid;border-width:3px'
cardClasses = 'col-md-3.bg-body-d5'

class ItemView extends Marionette.View
  template: itemTemplate
  templateContext:
    divStyle: 'border-style:solid;border-width:3px'
    cardClasses: '.bg-body-d5'
  className: 'col-md-2'
  ui:
    item: '.show-item'
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
  className: 'row'

class ListView extends Marionette.View
  template: listTemplate
  options:
    listContainer: listContainer
  ui: ->
    header: '.listview-header'
    itemList: listContainer
    flatListButton: '.flat-list'
    paginateBar: '.paginate-bar'
  regions:
    paginateBar: '@ui.paginateBar'
    itemList: '@ui.itemList'
  events:
    'click @ui.flatListButton': 'showFlatList'
  onRender: ->
    view = new ItemCollectionView
      collection: @collection
    @showChildView 'itemList', view
    pager = new PaginateBar
      collection: @collection
    @showChildView 'paginateBar', pager
  onBeforeDestroy: ->
    @collection.off 'pageable:state:change'
  showFlatList: ->
    navigate_to_url '#tvmaze/shows/flat'
    
module.exports = ListView

