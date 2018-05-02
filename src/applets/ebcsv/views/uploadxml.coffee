Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
Masonry = require 'masonry-layout'
tc = require 'teacup'

navigate_to_url = require('tbirds/util/navigate-to-url').default
{ make_field_input
  make_field_select } = require 'tbirds/templates/forms'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'ebcsv'

########################################
dropzone_template = tc.renderable (model) ->
  tc.article '.document-view.content', ->
    tc.div '.body', ->
      tc.div '.card', ->
        tc.div '.card-header', ->
          tc.text 'Drop an xml file, or use the '
          tc.button '.sample-comics-button.btn.btn-default', "Example data."
        tc.div '.card-body', ->
          tc.div '.parse-btn.btn.btn-default', style:'display:none', ->
            tc.text 'Parse Dropped File'
          tc.input '.xml-file-input.input', type:'file'
          tc.span '.parse-chosen-button.btn.btn-default',
          style:'display:none', ->
            tc.text 'Parse input file.'
  
class SampleComicsModel extends Backbone.Model
  url: '/assets/documents/sample-comics.xml'
  fetch: (options) ->
    options = options or {}
    options.dataType = 'text'
    return super options
  parse: (response, options) ->
    return content: response
            
class DropZoneView extends Backbone.Marionette.View
  template: dropzone_template
  droppedFile: null
  ui:
    status_msg: '.card-header'
    file_input: '.xml-file-input'
    parse_btn: '.parse-btn'
    chosen_btn: '.parse-chosen-button'
    sampleComicsBtn: '.sample-comics-button'
  events:
    'dragover': 'handle_dragOver'
    'dragenter': 'handle_dragEnter'
    'drop': 'handle_drop'
    'click @ui.parse_btn': 'parse_xml'
    'click @ui.file_input': 'file_input_clicked'
    'change @ui.file_input': 'file_input_changed'
    'click @ui.chosen_btn': 'parse_chosen_xml'
    'click @ui.sampleComicsBtn': 'parse_sample_xml'
    
    

  # https://stackoverflow.com/a/12102992
  file_input_clicked: (event) ->
    console.log "file_input_clicked", event
    @ui.file_input.val null
    @ui.chosen_btn.hide()

  file_input_changed: (event) ->
    console.log "file_input_changed", event
    @ui.chosen_btn.show()
    
  handle_drop: (event) ->
    event.preventDefault()
    @$el.css 'border', '0px'
    dt = event.originalEvent.dataTransfer
    file = dt.files[0]
    #console.log 'file is', file
    @ui.status_msg.text "File: #{file.name}"
    @droppedFile = file
    @ui.parse_btn.show()
    
  handle_dragOver: (event) ->
    event.preventDefault()
    event.stopPropagation()
    
  handle_dragEnter: (event) ->
    event.stopPropagation()
    event.preventDefault()
    @$el.css 'border', '2px dotted'

  successfulParse: =>
    @ui.status_msg.text "Parse Successful"
    if __DEV__
      window.comics = AppChannel.request 'get-comics'
    navigate_to_url "#ebcsv"

  parse_chosen_xml: ->
    @ui.status_msg.text "Reading xml file..."
    filename = @ui.file_input.val()
    #console.log "PARSE #{filename}"
    fi = @ui.file_input
    #console.log 'fi', fi, fi[0].files
    file = @ui.file_input[0].files[0]
    reader = new FileReader()
    reader.onload = @xmlReaderOnLoad
    reader.readAsText file
    @ui.parse_btn.hide()
    
  xmlReaderOnLoad: (event) =>
    content = event.target.result
    @ui.status_msg.text 'Parsing xml.....'
    AppChannel.request 'parse-comics-xml', content, @successfulParse
    
  parse_xml: ->
    @ui.status_msg.text "Reading xml file..."
    #console.log "PARSE #{@droppedFile.name}"
    reader = new FileReader()
    reader.onload = @xmlReaderOnLoad
    reader.readAsText(@droppedFile)
    @ui.parse_btn.hide()
    
  parse_sample_xml: ->
    model = new SampleComicsModel()
    response = model.fetch()
    @ui.status_msg.text "Retrieving xml...."
    response.done =>
      @ui.status_msg.text "Parsing xml...."
      xml = model.get 'content'
      AppChannel.request 'parse-comics-xml', xml, @successfulParse
    response.fail =>
      @ui.status_msg.text "Something failed."
      MessageChannel.danger "Failed to parse sample comics"
      
    
module.exports = DropZoneView


