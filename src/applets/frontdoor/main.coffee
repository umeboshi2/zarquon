import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import TkApplet from 'tbirds/tkapplet'

import Controller from './controller'

MainChannel = Backbone.Radio.channel 'global'
AppChannel = Backbone.Radio.channel 'frontdoor'

appletEntries = [
  {
    id: 'dbadmin'
    label: 'Db Admin'
    url: '#frontdoor/dbadmin'
    icon: '.fa.fa-database'
  }
]

class Router extends Marionette.AppRouter
  appRoutes:
    # handle empty route
    '': 'viewIndex'
    'frontdoor': 'viewIndex'
    'pages/:name': 'viewPage'
    'frontdoor/dbadmin': 'viewDbAdmin'
    
class Applet extends TkApplet
  Controller: Controller
  Router: Router
  appletEntries: [
    {
      label: 'Main Menu'
      menu: appletEntries
    }
  ]
  
export default Applet
