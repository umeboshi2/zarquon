Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

navigate_to_url = require 'tbirds/util/navigate-to-url'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'ebcsv'

########################################
Templates = require 'tbirds/templates/basecrud'

Views = require '../basecrudviews'

ItemTemplate = Templates.base_item_template 'description', 'ebcsv'
        
ListTemplate = Templates.base_list_template 'description'

class ItemView extends Views.BaseItemView
  route_name: 'ebcsv'
  template: ItemTemplate
  item_type: 'description'
  

  
class ListView extends Views.BaseListView
  route_name: 'ebcsv'
  childView: ItemView
  template: ListTemplate
  childViewContainer: '#description-container'
  item_type: 'description'
    
    
module.exports = ListView


