Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

navigate_to_url = require('tbirds/util/navigate-to-url').default


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'ebcsv'

########################################
Templates = require 'tbirds/templates/basecrud'

Views = require '../basecrudviews'

ItemTemplate = Templates.base_item_template 'config', 'ebcsv'
        
ListTemplate = Templates.base_list_template 'config'



#import tc from 'teacup'
marked = require 'marked'


{ form_group_input_div } = require 'tbirds/templates/forms'
capitalize = require 'tbirds/util/capitalize'

class ItemView extends Views.BaseItemView
  route_name: 'ebcsv'
  template: ItemTemplate
  item_type: 'config'

  modelEvents:
    'change:name': 'render'
    

  
class ListView extends Views.BaseListView
  route_name: 'ebcsv'
  childView: ItemView
  template: ListTemplate
  childViewContainer: '#config-container'
  item_type: 'config'
    
    
module.exports = ListView

