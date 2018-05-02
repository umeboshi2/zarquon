# CSS Authoring

## Compass

This project uses [compass](http://compass-style.org) to create 
the [CSS](http://en.wikipedia.org/wiki/Cascading_Style_Sheets) resources 
that will be used by the web application.  I have chosen to 
use [Sassy CSS](http://sass-lang.com)
[docs](http://sass-lang.com/documentation/file.SASS_REFERENCE.html) 
as the syntax to author the css resources.  Being an extension of the 
syntax of CSS3, any valid css file can be used directly as a scss file,
developer to fully use the compass framework on css files that have 
already been designed for other sites.

### Plugins

This project uses the [bootstrap-sass](https://github.com/twbs/bootstrap-sass) 
plugin for compass, making it easier to customize pages that use the 
[bootstrap](http://getbootstrap.com/) framework.  Also, a helper for 
generating [jquery-ui](FIXME) themes,
[Compass UI](https://github.com/patrickward/compass-ui), is used in 
this probject.  At full size the bootstrap css file is 291K(120K,
compass compressed output), while the jqueryui css file is 77K(31k,
compass compressed output).  These sizes can be decreased by delving into
the scss provided by the plugins and only using what is needed for the
particular application.

This project provides an example of how both the 
bootstrap and jquery-ui plugins can be configured to use the same 
color themes, and there is a python script that generates the
scss files.  The example is imcomplete, but provides enough to 
direct the css developer on how to proceed.  A plugin for creating 
buttons, [Sassy Buttons](http://jaredhardy.com/sassy-buttons/), is also 
being used.

### Icons
Finally, [FontAwesome](http://fontawesome.io/), is 
being used to provide icons.  The scss files are 
copied from the
[git repository](https://github.com/FortAwesome/Font-Awesome/tree/master/scss),
and may need to be updated.  In the future, I'd like to use
[font-awesome-sass](https://github.com/FortAwesome/font-awesome-sass) to
do this.  In the past, I had trouble integrating this into compass,
but it's possible that this problem has disappeared.  If it hasn't
disappeared, [bower](http://bower.io) can still be used to track the
upstream source and use a script to install the scss files into the
sass/partials directory.

### FullCalendar

The css file for [FullCalendar](http://arshaw.com/fullcalendar/),
has been copied verbatim and renamed to an scss file.  This was 
done to exemplify how easy it is to directly import css into 
the project.

## Goals for Authoring Environment

The primary goal for using compass and scss syntax is to provide 
a person who designs webpages the tools to design in a manner they 
are most likely to be comfortable with.  Stylesheets that they have 
developed in other projects can be directly imported, then manipulated 
very easily.

The author of this project is a web page designer, but merely a 
web service/application designer.  The example scss may not be 
the most pleasing to the eye, and there are many styles variables 
that have not been modified to match the other colors, and there 
is some work to be done to make the example themes more coherent 
and pleasant.
