$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'

BootstrapFormView = require('tbirds/views/bsformview').default
navigate_to_url = require('tbirds/util/navigate-to-url').default

{ form_group_input_div } = require 'tbirds/templates/forms'


MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'tvmaze'

searchForm = tc.renderable ->
  form_group_input_div
    input_id: 'input_show'
    label: 'TV Show'
    input_attributes:
      name: 'tv_show'
      placeholder: 'tiny toons'
  tc.input '.btn.btn-default.btn-sm', type:'submit', value:'Search'
  tc.div '.spinner.fa.fa-spinner.fa-spin'

class SearchFormView extends BootstrapFormView
  template: searchForm
  ui:
    tvShow: '[name="tv_show"]'
  createModel: ->
    MClass = AppChannel.request 'get-local-tvshow-model'
    return new MClass
  updateModel: ->
    @tvshow = @ui.tvShow.val()
    
  saveModel: ->
    rmodel = AppChannel.request 'single-show-search', @tvshow
    response = rmodel.fetch()
    response.done ->
      p = AppChannel.request 'save-local-show', rmodel.toJSON()
      p.then (result) ->
        navigate_to_url "#tvmaze/shows/view/#{rmodel.id}"
    response.fail =>
      MessageChannel.request 'warning', "#{@tvshow} not found."
      @trigger 'save:form:failure', @model
          

      
    #@model.save {}, callbacks
    
    
    
module.exports = SearchFormView

