Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
JView = require 'json-view'
require 'json-view/devtools.css'

navigate_to_url = require('tbirds/util/navigate-to-url').default

noImage = require('tbirds/templates/no-image-span').default
#PointerOnHover = require('tbirds/behaviors/pointer-on-hover').default
HasHeader = require('tbirds/behaviors/has-header').default

MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'tvmaze'

showTemplate = tc.renderable (model) ->
  show = model.show
  tc.div '.card.bg-body-d5', ->
    tc.div '.row', ->
      tc.div '.col-md-2', ->
        if show.image?.medium
          tc.img '.main-image.card-img-bottom', src:show.image.medium
        else
          noImage '5x'
      tc.div '.col-md-9', ->
        tc.div '.card-block.bg-body-d10', ->
          tc.h3 '.card-title', show.name
          tc.h4 "Premiered: #{new Date(show.premiered).toDateString()}"
          tc.raw show.summary
        tc.button '.select-show.btn.btn-primary',
        style:'display:none', "Select this show"

class ShowResultView extends Marionette.View
  template: showTemplate
  ui:
    selectShow: '.select-show'
    mainImage: '.main-image'
  events:
    'click @ui.selectShow': 'selectShow'
    'mouseenter @ui.mainImage': 'handleImageHover'
    'click @ui.mainImage': 'viewShow'
  inLocalCollection: ->
    id = @model.toJSON().show.id
    collection = @getOption 'localCollection'
    return collection.get id
  onRender: ->
    if not @inLocalCollection()
      @ui.selectShow.show()
  handleImageHover: ->
    if @inLocalCollection()
      @ui.mainImage.css
        cursor: 'pointer'
  viewShow: ->
    id = @model.toJSON().show.id
    navigate_to_url "#tvmaze/shows/view/#{id}"
    
  selectShow: ->
    id = @model.toJSON().show.id
    show = AppChannel.request 'get-remote-show', id
    response = show.fetch()
    response.done ->
      p = AppChannel.request 'save-local-show', show.toJSON()
      p.then (result) ->
        navigate_to_url "#tvmaze/shows/view/#{id}"
    response.fail ->
      MessageChannel.request 'danger', "Bad move"
      
  

class SearchResultsView extends Marionette.View
  template: tc.renderable (model) ->
    tc.div '.listview-header', ->
      tc.text "Matched TV Shows"
    tc.div '.show-list'
  ui:
    header: '.listview-header'
    itemList: '.show-list'
  regions:
    itemList: '@ui.itemList'
  behaviors:
    HasHeader:
      behaviorClass: HasHeader
  onRender: ->
    @ui.header.hide()
    view = new Marionette.CollectionView
      collection: @collection
      childView: ShowResultView
      childViewOptions:
        localCollection: AppChannel.request 'get-local-tvshows'
    @showChildView 'itemList', view
  
        

module.exports = SearchResultsView


