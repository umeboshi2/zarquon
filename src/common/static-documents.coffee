$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'

class StaticDocument extends Backbone.Model
  url: ->
    return "/assets/documents/#{@id}.md"
  
  fetch: (options) ->
    options = _.extend options || {},
      dataType: 'text'
    return super options

  parse: (response) ->
    return content: response
    
DocChannel.reply 'get-document', (name) ->
  model = new StaticDocument
    id: name
  return model
  
module.exports =
  StaticDocument: StaticDocument
  

