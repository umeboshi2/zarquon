$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'

navigate_to_url = require('tbirds/util/navigate-to-url').default
PaginateBar = require('tbirds/views/paginate-bar').default


MessageChannel = Backbone.Radio.channel 'messages'

itemTemplate = tc.renderable (model) ->
  itemBtn = '.btn.btn-sm'
  tc.li '.list-group-item.bg-body-d5', ->
    tc.span ->
      tc.a href:"", model.person.name

listTemplate = tc.renderable ->
  tc.div '.listview-header', ->
    tc.text "US Gov Roles"
  tc.div '.paginate-bar'
  tc.div '.navbox'
  tc.ul ".list-group"


navigateTemplate = tc.renderable ->
  tc.div '.btn-group', ->
    tc.button '.prev.btn.btn-secondary', type:'button', ->
      tc.i '.fa.fa-arrow-left'
    tc.button '.next.btn.btn-secondary', type:'button', ->
      tc.i '.fa.fa-arrow-right'
    
class NavigateBox extends Marionette.View
  template: navigateTemplate
  ui:
    prevButton: '.prev'
    nextButton: '.next'
  events:
    'click @ui.prevButton': 'getPreviousPage'
    'click @ui.nextButton': 'getNextPage'
  templateContext: ->
    collection: @collection
  _onFirstPage: ->
    state = @collection.state
    diff = state.currentPage - state.firstPage
    return diff is 0
    
  updateNavButtons: ->
    if @_onFirstPage()
      @ui.prevButton.hide()
    else
      @ui.prevButton.show()
    currentPage = @collection.state.currentPage
    if currentPage != @collection.state.lastPage
      @ui.nextButton.show()
    else
      @ui.nextButton.hide()
    if @collection.state.totalRecords is 0
      @ui.prevButton.hide()
      @ui.nextButton.hide()

  keyCommands:
    prev: 37
    next: 39
  handleKeyCommand: (command) ->
    if command in ['prev', 'next']
      @getAnotherPage command
  keydownHandler: (event) =>
    for key, value of @keyCommands
      if event.keyCode is value
        @handleKeyCommand key

  onRender: ->
    @updateNavButtons()
    @collection.on 'pageable:state:change', =>
      @updateNavButtons()
    $('html').keydown @keydownHandler

  onBeforeDestroy: ->
    @collection.off "pageable:state:change"
    $("html").unbind "keydown", @keydownHandler

  getAnotherPage: (direction) ->
    currentPage = @collection.state.currentPage
    onLastPage = currentPage is @collection.state.lastPage
    response = undefined
    if direction is 'prev' and currentPage
      response = @collection.getPreviousPage()
    else if direction is 'next' and not onLastPage
      response = @collection.getNextPage()
    if __DEV__ and response
      response.done ->
        console.log "Cleanup?"
  getPreviousPage: ->
    @getAnotherPage 'prev'
  getNextPage: ->
    @getAnotherPage 'next'
    
class ItemView extends Marionette.View
  template: itemTemplate
  ui:
    item: '.list-group-item'
    link: 'a'
  events:
    'click @ui.link': 'showRole'
  showRole: (event) ->
    event.preventDefault()
    MessageChannel.request 'success', 'Cool!'
    
class ItemCollectionView extends Marionette.CollectionView
  childView: ItemView

class ListView extends Marionette.View
  template: listTemplate
  ui:
    header: '.listview-header'
    itemList: '.list-group'
    paginateBar: '.paginate-bar'
  regions:
    itemList: '@ui.itemList'
    paginateBar: '@ui.paginateBar'
    navBox: '.navbox'
  onRender: ->
    view = new ItemCollectionView
      collection: @collection
    @showChildView 'itemList', view
    view = new PaginateBar
      collection: @collection
      setKeyHandler: true
    @showChildView 'paginateBar', view
    #view = new NavigateBox
    #  collection: @collection
    #@showChildView 'navBox', view
    
view_template = tc.renderable (model) ->
  tc.div '.row.listview-list-entry', ->
    tc.raw marked "# #{model.appName} started."
    
class MainView extends Marionette.View
  template: view_template
  templateContext:
    appName: 'usgov'
    
module.exports = ListView

