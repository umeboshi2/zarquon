import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import TkApplet from 'tbirds/tkapplet'

require './dbchannel'
require './ebutils'

import Controller from './controller'

MainChannel = Backbone.Radio.channel 'global'
ResourceChannel = Backbone.Radio.channel 'resources'

menuEntries = [
  {
    id: 'main'
    label: 'Main View'
    url: '#ebcsv'
    icon: '.fa.fa-eye'
  },{
    id: 'cfglist'
    label: 'Configs'
    url: '#ebcsv/configs/list'
    icon: '.fa.fa-list'
  },{
    id: 'dsclist'
    label: 'Descriptions'
    url: '#ebcsv/descriptions/list'
    icon: '.fa.fa-list'
  },{
    id: 'uploadxml'
    label: 'Upload CLZ/XML'
    url: '#ebcsv/xml/upload'
    icon: '.fa.fa-upload'
  },{
    id: 'mkcsv'
    label: 'Create CSV'
    url: '#ebcsv/csv/create'
    icon: '.fa.fa-cubes'
  },{
    id: 'cached'
    label: 'Cached Images'
    url: '#ebcsv/clzpage'
    icon: '.fa.fa-image'
  },{
    id: 'addcfg'
    label: 'Create Cfg'
    url: '#ebcsv/configs/add'
    icon: '.fa.fa-plus'
  }
  ]

class Router extends Marionette.AppRouter
  appRoutes:
    'ebcsv': 'main_view'

    'ebcsv/xml/upload': 'upload_xml'
    'ebcsv/csv/create': 'create_csv'
    'ebcsv/csv/preview': 'preview_csv'

    'ebcsv/clzpage' : 'view_cached_comics'
    
    'ebcsv/configs': 'list_configs'
    'ebcsv/configs/list': 'list_configs'
    'ebcsv/configs/add': 'add_new_config'
    'ebcsv/configs/view/:name': 'view_config'
    'ebcsv/configs/edit/:name': 'edit_config'


    'ebcsv/descriptions': 'list_descriptions'
    'ebcsv/descriptions/list': 'list_descriptions'
    'ebcsv/descriptions/add': 'add_new_description'
    'ebcsv/descriptions/view/:name': 'view_description'
    'ebcsv/descriptions/edit/:name': 'edit_description'

class Applet extends TkApplet
  Controller: Controller
  Router: Router
  appletEntries: [
    {
      label: "Ebcsv Menu"
      menu: menuEntries
    }
  ]
  state:
    currentCsvAction: undefined
    currentCsvConfig: undefined
    currentCsvDsc: undefined
       
export default Applet
