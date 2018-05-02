# Application Development Environment



## Backbone.Marionette

Marionette is the main application framework.  Marionette makes 
it easier to organize application code into smaller more 
manageable module.  It uses a communication mechanism to 
decouple the components of the application, making it easier to 
develop each part separately.

### Application Model

An application model looks like this:

- AppModel
  - brand:
	- name: 'App Name'
	- url: '#'
  - apps: 
	- { appname:'', name:'', url:''}
  - appregions
  - approutes


### Common Modules (these don't exist anymore)

Common modules exist in the common/ directory.

#### appregions

This module contains the default appregion objects which can
be passed to the addRegions method of the
[application](http://marionettejs.com/docs/marionette.application.html)
object.  There is a basic object for a static application, as well
as one for applications that have authenticated users.

This module also has a function to prepare the application.  It adds
the [regions](http://marionettejs.com/docs/marionette.region.html)
described in the appregions property of the appmodel object.  It adds
default show and empty view handlers on the main message bus for each
region described in the appregions object, in the
form appregion:{region}:{action}.  It also adds the routes described
in the approutes property of the appmodel.

#### approuters

This is just a simple
[AppRouter](http://marionettejs.com/docs/marionette.approuter.html)
that updates the navbar when the child app changes.

### controllers

There is a simple SideBarController that doesn't do very much but help
maintain a "side bar", which is a common feature of many controllers.
This module exists to provide common functionality to controllers
when the need arises.

### mainpage

This module needs to be fixed, as it is too constrictive concerning
the views and layout that are used on all the pages.  However, this
module does provide a common *initialize_page* function that nests
the rendering of the navbar view upon completion of the rendering
of the main layout.  The main layout contains most of the elements
of the default appregions.  The main layout is currently a bootstrap
two column layout with a fixed navbar.  This function needs to be
updated to handle different layouts and nested views.  This function
is contained in a message bus wrapper with the signal *mainpage:init*.


There is also a function that sets a handler for when the
navbar is displayed to add a user menu view to the navbar.
This helps minimize the amount of code that distinguishes an
application that requires authenticated users, and static apps
that have no such requirements.

Every function exported in this module requires the MainBus
to be passed as a parameter to set handlers for the functionality.

### mainviews

There are four basic views defined here.  The main page layout,
as well as the navbar view are defined here.  There is also
a login view and a user menu view.  These views do nothing
but use specific templates in *common/templates*.

### templates

There are common templates here for the four views described
above. There is also a common template to create a side bar
with buttons, as well as a function to create a label and
input for a bootstrap form.

### models

There is a model here to contain the current authenticated
user of the application.  There must be a url on the
server that returns a "current user" object to fill the
model.


### Application Skeleton

The application skeleton was inspired by this github
[project](https://github.com/t2k/backbone.marionette-RequireJS),
which provides some simple boilerplate code to start
a single page application using marionette, coffeescript, and
requirejs.  It also taught me to use bower to manage the
components and their dependencies.

- **main (main-local)**
  This is where the requirejs config is located.  This file is 
  responsible for importing the application module and starting
  the application.
- **application**
  - This module is responsible for the initial setup of the
	[application](http://marionettejs.com/docs/marionette.application.html).
  - This module sets the
	[Regions](http://marionettejs.com/docs/marionette.region.html)
	for the main page.
  - It starts the
	[AppRouters](http://marionettejs.com/docs/marionette.approuter.html)
	of all the sub applications.
  - If logins are used, this module sets the handler for the user info
	and starts the app after fetching the user info.
- **models** and **collections**
  These provide access to
  [models](http://backbonejs.org/#Model) and
  [collections](http://backbonejs.org/#Collection) that are 
  global to the application, such as "current user info" for
  the logged in user.
- **msgbus**
  This is the global
  [message bus]( https://github.com/marionettejs/backbone.wreqr)
  (MainBus) that allows communication 
  between the main application and the sub apps.

### Child Application Skeleton

The child application exists *logically* in a subdirectory of
the main application root.  The structure of the child application,
along with the use of a separate message bus for each child application,
provides the ability to use the same child application in multiple
main apps, if needed.  If the child application is not in the subdirectory
of the main application, the path needs to be configured in requirejs
config object.

- **main**
  - The main module is responsible creating the router that maps
	the routes to methods on the controller.
- **models** and **collections**
  - These modules provide the models and collections specific to
	the child application.
- **msgbus**
  - This is the child specific message bus (AppBus).  The channel
	it defines *must* have a unique name.
- **controller**
  - The [controller](http://marionettejs.com/docs/marionette.controller.html)
	basically handles the route requests by managing the views
	for those routes.
- **views**
  These are the
  [views](http://marionettejs.com/docs/marionette.region.html)
  that will be used in this child application.
- **templates**
  These are the teacup templates for the views in this child application.

### Frontdoor Application

The frontdoor application is the default child application.  One
child application must exist to perform the function of an "index.html"
page.  This can be considered the root path of the main application.
The frontdoor application can be required last in the application module
and interact with the functionality of those child applications, such as
accessing models, collections, templates, and views of those child
applications with the controller of the frontdoor application.

