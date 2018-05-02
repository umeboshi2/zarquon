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
      
  tc.input '.btn.btn-primary.btn-sm', type:'submit', value:'Search'
  tc.div '.spinner.fa.fa-spinner.fa-spin.text-primary'

class SearchFormView extends BootstrapFormView
  template: searchForm
  ui:
    tvShow: '[name="tv_show"]'
  createModel: ->
    return new Backbone.Model
  updateModel: ->
    @tvshow = @ui.tvShow.val()
    @model.set 'tvshow', @tvshow
  saveModel: ->
    response = @collection.fetch
      data:
        q: @tvshow
    response.done =>
      @trigger 'save:form:success', @model
    response.fail =>
      MessageChannel.request 'warning', "#{@tvshow} not found."
      @trigger 'save:form:failure', @model
          
    
module.exports = SearchFormView

