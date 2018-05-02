import $ from 'jquery'
import Backbone from 'backbone'
import { LoveStore } from 'backbone.lovefield'

MainChannel = Backbone.Radio.channel 'global'
AppChannel = Backbone.Radio.channel 'ebcsv'

dbConn = MainChannel.request 'main:app:dbConn', 'ebcsv'

ConfigStore = new LoveStore dbConn, 'Config'
DescriptionStore = new LoveStore dbConn, "Description"
ComicUrlStore = new LoveStore dbConn, 'ComicUrl'

class LocalConfig extends Backbone.Model
  loveStore: ConfigStore
  
class LocalConfigCollection extends Backbone.Collection
  loveStore: ConfigStore
  model: LocalConfig


class LocalDescription extends Backbone.Model
  loveStore: DescriptionStore
    
class LocalDescCollection extends Backbone.Collection
  loveStore: DescriptionStore
  model: LocalDescription
  
class ComicImageUrl extends Backbone.Model
  loveStore: ComicUrlStore
  idAttrubute: -> return 'url'

class ComicImageUrlCollection extends Backbone.Collection
  loveStore: ComicUrlStore
  model: ComicImageUrl
  
local_configs = new LocalConfigCollection
local_descriptions = new LocalDescCollection
comic_urls = new ComicImageUrlCollection

AppChannel.reply 'get_local_configs', ->
  return local_configs
AppChannel.reply 'get-config-model', ->
  return LocalConfig
AppChannel.reply 'configCollection', ->
  return LocalConfigCollection
  
AppChannel.reply 'get_local_descriptions', ->
  return local_descriptions
AppChannel.reply 'get-description-model', ->
  return LocalDescription
AppChannel.reply 'descCollection', ->
  return LocalDescCollection
  
AppChannel.reply 'get_comic_urls', ->
  return comic_urls
AppChannel.reply 'get-comic-url-model', ->
  return ComicImageUrl
AppChannel.reply 'get-comic-url-collection', ->
  return ComicImageUrlCollection
  
class BaseLocalStorageModel extends Backbone.Model
  initialize: () ->
    @fetch()
    @on 'change', @save, @
  fetch: () ->
    @set JSON.parse localStorage.getItem @id
  save: (attributes, options) ->
    localStorage.setItem(@id, JSON.stringify(@toJSON()))
    return $.ajax
      success: options.success
      error: options.error
  destroy: (options) ->
    localStorage.removeItem @id
  isEmpty: () ->
    _.size @attributes <= 1


ReqFieldNames = [
  'format'
  'location'
  'returnsacceptedoption'
  'duration'
  'quantity'
  'startprice'
  'dispatchtimemax'
  'conditionid'
  ]

AppChannel.reply 'csv-req-fieldnames-local', ->
  ReqFieldNames

OptFieldNames = [
  'postalcode'
  'paymentprofilename'
  'returnprofilename'
  'shippingprofilename'
  'scheduletime'
  ]
  
AppChannel.reply 'csv-opt-fieldnames-local', ->
  OptFieldNames
  
class BaseCsvFieldsModel extends BaseLocalStorageModel

class BaseReqFieldsModel extends BaseCsvFieldsModel
  fieldType: 'required'
  fieldNames: ReqFieldNames
  
class BaseOptFieldsModel extends BaseCsvFieldsModel
  fieldType: 'optional'
  fieldNames: OptFieldNames



AppChannel.reply 'get-comic-image-urls', ->
  console.warn "get-comic-image-urls"
  comic_image_urls = new BaseLocalStorageModel
    id: 'comic-image-urls'
  comic_image_urls.toJSON()

AppChannel.reply 'add-comic-image-url', (url, image_src) ->
  comic_image_urls = new BaseLocalStorageModel
    id: 'comic-image-urls'
  comic_image_urls.set url, image_src
  #comic_image_urls.save()
  
AppChannel.reply 'clear-comic-image-urls', ->
  comic_image_urls = new BaseLocalStorageModel
    id: 'comic-image-urls'
  comic_image_urls.destroy()
  #delete localStorage[comic_image_urls.id]
  console.log "localStorage", localStorage[comic_image_urls.id]
  
AppletLocals = {}
AppChannel.reply 'applet:local:get', (name) ->
  AppletLocals[name]

AppChannel.reply 'applet:local:set', (name, value) ->
  AppletLocals[name] = value
AppChannel.reply 'applet:local:delete', (name) ->
  delete AppletLocals[name]
  
  

current_csv_action = undefined
AppChannel.reply 'set-current-csv-action', (action) ->
  #current_csv_action = action
  AppChannel.request 'applet:local:set', 'currentCsvAction', action
AppChannel.reply 'get-current-csv-action', ->
  #current_csv_action
  AppChannel.request 'applet:local:get', 'currentCsvAction'
  
current_csv_cfg = undefined
AppChannel.reply 'set-current-csv-cfg', (cfg) ->
  #current_csv_cfg = cfg
  AppChannel.request 'applet:local:set', 'currentCsvCfg', cfg
AppChannel.reply 'get-current-csv-cfg', ->
  #current_csv_cfg
  AppChannel.request 'applet:local:get', 'currentCsvCfg'
  
current_csv_dsc = undefined
AppChannel.reply 'set-current-csv-dsc', (dsc) ->
  #current_csv_dsc = dsc
  AppChannel.request 'applet:local:set', 'currentCsvDsc', dsc
AppChannel.reply 'get-current-csv-dsc', ->
  #current_csv_dsc
  AppChannel.request 'applet:local:get', 'currentCsvDsc'

class SuperHeroList extends Backbone.Model
  url: '/assets/data/superheroes.json'

hero_list = new SuperHeroList
AppChannel.reply 'get-superheroes-model', ->
  hero_list



