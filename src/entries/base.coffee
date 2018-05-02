import $ from 'jquery'
import _ from 'underscore'
import Backbone from 'backbone'
import Marionette from 'backbone.marionette'

import 'bootstrap'
import 'font-awesome/scss/font-awesome.scss'
# FIXME need better way to resolve tbirds sass
if not __useCssModules__
  require '../../node_modules/tbirds/sass/cornsilk.scss'
else
  require '../../node_modules/tbirds/sass/initial.scss'

import "es6-promise/auto"
import stringEndsWith from 'tbirds/util/polyfills/str-endswith'
import stringStartsWith from 'tbirds/util/polyfills/str-startswith'
# use polyfill for String.endsWith if needed
if not String.prototype?.endsWith
  String.prototype.endsWith = stringEndsWith
if not String.prototype.startsWith
  String.prototype.startsWith = stringStartsWith
  



if __DEV__
  console.warn "__DEV__", __DEV__, "DEBUG", DEBUG
  Backbone.Radio.DEBUG = true

require 'tbirds/applet-router'
IsEscapeModal = require('tbirds/behaviors/is-escape-modal').default


require '../common/static-documents'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

if __DEV__
  require '../inspector'
  
class BaseModalView extends Marionette.View
  behaviors: [IsEscapeModal]
  ui:
    close_btn: '#close-modal div'
    
MainChannel.reply 'main:app:BaseModalView', ->
  BaseModalView
  
show_modal = (view, backdrop=false) ->
  app = MainChannel.request 'main:app:object'
  modal_region = app.getView().getRegion 'modal'
  modal_region.backdrop = backdrop
  modal_region.show view

MainChannel.reply 'show-modal', (view, backdrop=false) ->
  console.warn 'show-modal', backdrop
  show_modal view, false
  

