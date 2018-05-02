# Web Development Environment

## Node.js

(born on February 15, 2009)

A [node.js](//nodejs.org) environment is used to develop and
build the web applications.  Using nodejs is essential for meaningful web 
development.


## CoffeeScript

(born on December 13, 2009)

The development environment uses [CoffeeScript](//coffeescript.org/).  This 
may change eventually depending on how it eventually targets 
[es6](//github.com/lukehoban/es6features) features.

## Gulp

(born on July 4, 2013)

[Gulp](//gulpjs.com) is used for task automation when developing.  Gulp 
has replaced grunt and seems to be a bit more pluggable and extensible.

Here is the ["gulpfile.coffee"](/gulpfile.coffee) for this website.


## Webpack 

(born on March 10, 2012)

[Webpack](//webpack.github.io) is a module bundler, and is very useful 
for preparing and deploying the static resources.  Using webpack removed 
the need for requirejs, and most of the bower dependencies became nodejs 
dependencies, making the environment more coherent.

Here are the [development](/webpack.config.coffee) and 
[production](/webpack.prod.config.coffee) configurations.  Common config 
options are to be loaded from the "webpack-config" 
[directory](/webpack-config/).



This project uses a collection of javascript resources to help 
develop applications.  The collection is rather large when 
the ace editor is included, and at the time of this writing,
the built and minified [conspectus](http://umeboshi2.github.io/conspectus)
app is 329 Kilobytes.  This collection is provided to assist 
in application development, but not all components are necessary 
for every application that is intended.

## Basic Components

-  [jQuery](http://jquery.com/): 
   jQuery is a very good for selecting and maninpulating elements in the DOM.

-  [Bootstrap v3](http://getbootstrap.com/): 
   Bootstrap is a CSS/Javascript framework used to help make responsive 
   websites.  Bootstrap was selected to be used in order to serve to 
   mobile devices.  The CSS is handled through compass with bootstrap-sass.
   **version 4**
   
-  [Underscore.js](http://underscorejs.org/): 
   Underscore is a library full of useful utilities, and like jqueryui, is 
   depended upon by other javascript libraries I use.

-  [Backbone.js](http://backbonejs.org/): 
   Backbone is an excellent library that provides an api to make very 
   rich views tied to models that are seamlessly synchronized with 
   the server via a REST interface.

-  [Marionette](http://marionettejs.com/):
   "Backbone.Marionette is a composite application library for 
   Backbone.js that aims to simplify the construction of large scale 
   JavaScript applications," and it is very effective at doing this.
   This is the primary library used in this project for creating 
   single page applications.

-  [Teacup](http://goodeggs.github.io/teacup/):
   "Teacup is templates in CoffeeScript."
   Teacup makes it very easy to create html templates
   for backbone.  It is a 
   [domain specific language](http://en.wikipedia.org/wiki/Domain-specific_language) 
   for coffeescript that makes it pleasant to use as a 
   microtemplating solution.  Currently, almost all the 
   html rendered by the application is done with teacup.

The foregoing components comprise the minimal set of libraries 
that should be considered *required* for application development.  The 
bootstrap component shouldn't be seen as *strictly required*, but 
it is small and useful for a responsive environment.  A similar 
argument could be made for teacup as well, but since the development 
environment is a coffeescript environment, teacup fits really well.

While it is up to the application developer to decide upon the
minimal framework required, the stack above is a good collection 
that provides a lot of ability in a small stack size.



## Other Components

-  [jQuery User Interface](http://jqueryui.com/): 
   jQueryUI is used for the fullcalendar widget, as well as for dialog boxes 
   and other user interface elements that aren't used through boostrap.  The 
   corresponding styles are maintained with compass.

-  [FullCalendar](http://arshaw.com/fullcalendar/): 
   FullCalendar is a very good library that provides an interactive 
   calendar where events can be retrieved dynamically and grouped, 
   colored, or otherwised styled in many ways.  The calendar provides 
   monthly, weekly, and daily view models to interact with.

-  [Ace Editor](http://ace.c9.io/#nav=about): 
   The ACE editor is a good text editor that is very useful for 
   editing html, css, java/coffee scripts, and other formats that
   aren't being used yet.
   

