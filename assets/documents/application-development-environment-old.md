# Application Development Environment

## Development Environments

Vagrant is the development environment of choice, since it
requires the least amount of changes to the operating system.
All that is needed is virtualbox and the vagrant application.  In
the future, docker will be used to contain the development
environment.  Using vagrant allows for better server side development,
where the developer can configure services that won't interfere
with the developer's system.  The environment is configured
using [salt](http://www.saltstack.com).

An alternative to using vagrant, which is the alternative used
on my netbook of limited resources, is to use schroot to
contain the development enviroment in a chroot.  This can also
be configured with salt, and a script exists in the scripts/
directory to achieve this.

Of course, development can be done natively in the operating system,
if desired.

## node.js

A [node.js](http://nodejs.org) environment is used to develop and
build the applications.  [Grunt](http://gruntjs.com/) is used to
build and optimize the static resources for the client application.
The Gruntfile is written in coffeescript.  [bower](http://bower.io)
is also used in the node environment to install the upstream
static resources needed by the application.

## CoffeeScript

[CoffeeScript](http://coffeescript.org/) is used as the language 
of choice for developing applications with 
[Backbone.Marionette](http://marionettejs.com/).  When I began 
noticing the necessity of learning javascript to achieve a 
better application platform, I decided to use coffeescript for 
a large number of reasons.  I had already been hesitant to use 
javascript, so being a python developer, I started by looking 
at javascript alternatives that would allow me to perform 
client side development without a heavy investment into learning 
another language.  I came across some projects that took a 
python file and compiled it into javascript, but this turned 
out to be a greater hassle than expected.

I happened to chance upon coffee script one day and decided to 
try it out.  While I was initially using it to provide a 
whitespace environment for creating javascript, I found that
the coffeescript language provides a lot of valuable assistance to a 
person learning to program in a javascript environment.  Not 
only does the syntactic sugar provide for cleaner and more 
readable code, it also provides readable reliability when performing 
some common actions that are a bit tricky to do correctly in 
javascript, such as testing for *undefined*.  Even more valuable 
is the default behaviour to wrap the code in an anonymous function,
and also forcing every variable to be declared locally on first chance 
in that anonymous function, making it very difficult to pollute 
the global namespace accidentally.

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


### Common Modules

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

