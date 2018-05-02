{ map } = require 'underscore'
$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'

navigate_to_url = require('tbirds/util/navigate-to-url').default
{ ProgressModel
  ProgressView } = require 'tbirds/views/simple-progress'

console.log "ProgressModel", ProgressModel
console.log "ProgressView", ProgressView

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'tvmaze'

data = require '../../../../assets/dev/myshows.json'
console.log data

shows = new Backbone.Collection data
console.log "Shows", shows


class ImportManager extends Marionette.Object
  channelName: 'tvmaze'
  collection: shows
  initialize: (options) =>
    @progressModel = options.progressModel
    
saveRemoteShow = (id) ->
  show = AppChannel.request 'get-remote-show', id
  response = show.fetch()
  response.done ->
    p = AppChannel.request 'save-local-show', show.toJSON()
    return p
  return response

saveEpisodes = (collection, showID, navigate) ->
  promises = []
  collection.models.forEach (model) ->
    data =
      id: model.get 'id'
      show_id: showID
      content: model.toJSON()
    p = AppChannel.request 'save-local-episode', data
    promises.push p
  Promise.all(promises).then (data) ->
    if promises.length and navigate
      navigate_to_url "#tvmaze/shows/view/#{showID}"
    MessageChannel.request 'success', "Retrieved #{promises.length} episodes."
  

itemTemplate = tc.renderable (model) ->
  itemBtn = '.btn.btn-sm'
  tc.li '.list-group-item', ->
    tc.span ->
      tc.a '.import-single-show', href:"#", model.name
    tc.span '.btn-group.pull-right', ->
      tc.button '.delete-item.btn.btn-sm.btn-danger.fa.fa-close', 'delete'
    

mainTemplate = tc.renderable (post) ->
  tc.div '.body.col-md-6', ->
    tc.h1 'TV Maze Sample Data'
    tc.div '.form-inline', ->
      tc.div '.form-check', ->
        tc.input '#include-episodes.form-check-input', type:'checkbox'
        tc.label '.form-check-label', for:'include-episodes', 'Include episodes'
      tc.button '.import-button.btn.btn-primary.btn-sm', 'Import Data'
    tc.div '.status-div.alert.alert-info', style:'display:none'
    tc.div '.import-progress'
    tc.ul '.show-list.list-group'

class ShowView extends Marionette.View
  channelName: 'tvmaze'
  template: itemTemplate
  ui:
    deleteButton: '.delete-item'
    importSingleAnchor: '.import-single-show'
  events:
    'click @ui.deleteButton': 'deleteItem'
    'click @ui.importSingleAnchor': 'importShow'
  triggers:
    'click @ui.deleteButton': 'item:deleted'
    'click @ui.importSingleAnchor': 'import:show'
  deleteItem: ->
    @trigger 'item:deleted', @model
    @triggerMethod 'item:deleted', @model
    @model.collection.remove @model
  importShow: (event) ->
    event.preventDefault()
    
class MainView extends Marionette.View
  channelName: 'tvmaze'
  template: mainTemplate
  ui:
    showList: '.show-list'
    statusDiv: '.status-div'
    importProgress: '.import-progress'
    importButton: '.import-button'
    includeEpisodes: '#include-episodes'
  regions:
    showList: '@ui.showList'
    importProgress: '@ui.importProgress'
  events:
    'click @ui.importButton': 'importShows'
  onRender: ->
    local_shows = AppChannel.request 'get-local-tvshows'
    models = shows.models
    console.log "SHOWS", shows, shows.models[0]
    counter = 0
    removals = []
    while counter < shows.length
      model = shows.models[counter]
      if model.id == 6544
        console.log "MODEL". model
      lmodel = local_shows.get model.id
      if lmodel
        removals.push model
      counter += 1
    shows.remove removals
    
        
    @importProgressModel = new ProgressModel
    @importProgressModel.set 'valuemax', shows.length
    @importProgressModel.set 'valuenow', 0
    view = new Marionette.CollectionView
      channelName: 'tvmaze'
      collection: shows
      childView: ShowView
      childViewTriggers:
        'item:deleted': 'child:item:deleted'
        'import:show': 'child:import:show'
      onChildItemDeleted: =>
        @importProgressModel.set 'valuemax', shows.length
      onChildImportShow: (view) =>
        console.log "onChildImportShow", view
        id = view.model.id
        includeEpisodes = @ui.includeEpisodes.prop 'checked'
        show = AppChannel.request 'get-remote-show', id
        response = show.fetch()
        response.done ->
          p = AppChannel.request 'save-local-show', show.toJSON()
          p.then (result) ->
            if includeEpisodes
              console.log "get episodes too"
              console.log show
              MessageChannel.request "info", "Retrieving episodes...."
              ecoll = AppChannel.request 'get-remote-episodes', id
              response = ecoll.fetch()
              response.done ->
                saveEpisodes ecoll, id
        
    
    @showChildView 'showList', view
    view = new ProgressView
      model: @importProgressModel
    @showChildView 'importProgress', view
  importShows: ->
    @ui.importButton.hide()
    @ui.statusDiv.show()
    console.log "importShows"
    @importAnotherShow()
  importShow: (show) ->
    name = show.get 'name'
    id = show.id
    @ui.statusDiv.text "Importing #{name}, #{id}"
    rshow = AppChannel.request 'get-remote-show', id
    response = rshow.fetch()
    response.done =>
      p = AppChannel.request 'save-local-show', rshow.toJSON()
      p.then (result) =>
        includeEpisodes = @ui.includeEpisodes.prop 'checked'
        if includeEpisodes
          console.log "get episodes too"
          console.log rshow
          MessageChannel.request "info", "Retrieving episodes...."
          ecoll = AppChannel.request 'get-remote-episodes', id
          response = ecoll.fetch()
          response.done =>
            saveEpisodes ecoll, id, false
            shows.remove show
            @importProgressModel.set 'valuenow', shows.length
            if shows.length
              setTimeout =>
                @importAnotherShow()
              , 500
        else
          shows.remove show
          @importProgressModel.set 'valuenow', shows.length
          if shows.length
            setTimeout =>
              @importAnotherShow()
            , 500
  importAnotherShow: ->
    show = shows.models[0]
    @importShow show
    
module.exports = MainView

