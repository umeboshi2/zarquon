$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
JView = require 'json-view'
require 'json-view/devtools.css'
FileSaver = require 'file-saver'

exportToFile = require('tbirds/util/export-to-file').default

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'ebcsv'

#class ComicListView extends Backbone.Marionette.CollectionView
#  childView: ComicEntryView

importExportTemplate = tc.renderable (model) ->
  tc.div '.listview-list-entry', ->
    tc.h2 model.name
    tc.div '.btn-group', ->
      tc.button '.view.btn.btn-success', type:'button', 'View'
      tc.button '.export.btn.btn-primary', type:'button', 'Export'
      tc.button '.import.btn.btn-info', type:'button', 'Import'
    tc.div '.dbview'

importExportTemplate = tc.renderable (model) ->
  tc.div '.card', ->
    tc.div '.card-header', ->
      tc.h2 model.name
    tc.div '.card-body', ->
      tc.div '.file-status', ->
        tc.text "Drop a .json exported database to import."
      tc.button '.view.btn.btn-success', type:'button', 'View'
      tc.button '.export.btn.btn-primary', type:'button', 'Export'
      tc.div '.import.btn.btn-info',
      type:'button', style:'display:none', ->
        tc.text "Import Database"
      tc.input '.db-file-input.input', type:'file'
      tc.button '.import-chosen.btn.btn-info', style:'display:none', ->
        tc.text 'Import input file'
      tc.div '.dbview'
      

class DatabaseView extends Marionette.View
  template: tc.renderable (model) ->
    tc.div ->
      tc.div '.body'
  ui:
    body: '.body'
  onDomRefresh: ->
    data = @model.toJSON()
    @jsonView = new JView data
    @ui.body.prepend @jsonView.dom
    #@jsonView.expand true
    
class ImportExportView extends Marionette.View
  template: importExportTemplate
  ui:
    viewButton: '.view'
    exportButton: '.export'
    importButton: '.import'
    dbView: '.dbview'
    fileInput: '.db-file-input'
    importChosenButton: '.import-chosen'
    fileStatus: '.file-status'
  regions:
    dbView: '@ui.dbView'
    #fileStatus: '@ui.fileStatus'
  events:
    'dragover': 'handleDragOver'
    'dragenter': 'handleDragEnter'
    'dragexit': 'handleDragExit'
    'drop': 'handleDrop'
    'click @ui.viewButton': 'viewDatabase'
    'click @ui.exportButton': 'exportDatabase'
    'click @ui.importButton': 'importDatabase'
    'click @ui.importChosenButton': 'importChosenFile'
    'click @ui.fileInput': 'fileInputClicked'
    'change @ui.fileInput': 'fileInputChanged'

  # https://stackoverflow.com/a/12102992
  fileInputClicked: (event) ->
    @ui.fileInput.val null
    @ui.importChosenButton.hide()

  fileInputChanged: (event) ->
    @ui.importChosenButton.show()

  handleDrop: (event) ->
    event.preventDefault()
    @$el.css 'border', '0px'
    dt = event.originalEvent.dataTransfer
    file = dt.files[0]
    @droppedFile = file
    text = "File: #{file.name}"
    @ui.fileStatus.text text
    @ui.importButton.show()
    
  handleDragOver: (event) ->
    event.preventDefault()
    event.stopPropagation()
    
  handleDragEnter: (event) ->
    event.stopPropagation()
    event.preventDefault()
    @$el.css 'border', '2px dotted'
  
  handleDragExit: (event) ->
    event.stopPropagation()
    event.preventDefault()
    @$el.css 'border', '0px'
      
  _exportDatabase: ->
    conn = @model.get 'conn'
    return conn.export()
    
  viewDatabase: ->
    @_exportDatabase().then (data) =>
      view = new DatabaseView
        model: new Backbone.Model data: data
      @showChildView 'dbView', view
      @ui.viewButton.hide()
      
  exportDatabase: ->
    p = @_exportDatabase()
    p.then (data) =>
      name = @model.get 'name'
      options =
        type: 'data:text/json;charset=utf-8'
        data: JSON.stringify data
        filename: "#{name}-idb.json"
      #exportToFile options
      blob = new Blob([options.data], type:options.type)
      FileSaver.saveAs(blob, options.filename)
      MessageChannel.request 'primary', "Exported Database #{name}"

  fileReaderOnLoad: (event) =>
    content = JSON.parse event.target.result
    @ui.fileStatus.text "Database file loaded, now importing...."
    conn = @model.get 'conn'
    conn.import(content).then =>
      @viewDatabase()
      
    
  importDatabase: ->
    MessageChannel.request 'info', "Import Database #{@model.get 'name'}"
    @ui.fileStatus.text 'Reading dabase file.....'
    reader = new FileReader()
    reader.onload = @fileReaderOnLoad
    reader.readAsText(@droppedFile)
    @ui.importButton.hide()
    

class MainView extends Backbone.Marionette.View
  regions:
    body: '.body'
  template: tc.renderable (model) ->
    tc.div '.listview-header', ->
      tc.text "Indexed Database Admin"
    tc.div '.body'
  onRender: ->
    app = MainChannel.request 'main:app:object'
    dbConn = app.getState 'dbConn'
    @collection = new Backbone.Collection
    view = new Marionette.CollectionView
      collection: @collection
      childView: ImportExportView
    @showChildView 'body', view
    Object.keys(dbConn).forEach (key) =>
      @collection.add
        id: key
        name: key
        conn: dbConn[key]
    
      
module.exports = MainView


