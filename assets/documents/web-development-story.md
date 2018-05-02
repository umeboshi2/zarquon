#Title

##Outline

- Aversion to html, css, and javascript.
  - ugly and cumbersome, unpleasant to work with
  - too many browsers to support (still a problem)
  - play with apache, python and cgi
- Start making simple Web Application
  - cherrypy, pylons, forgethtml
  - href="javascript:document.location.reload()"
	- or: [reload](javascript:document.location.reload())
- Long Pause
  - desktop gui starts losing appeal when changing api's, support
	for transitions, and other related problems makes code maintainence
	more time consuming
- [HTML5](http://en.wikipedia.org/wiki/HTML5)
  - This seemed to be a good promise of long term multiplatform
	compatibility with a large feature set.
  - Still have ugly html, css, and javascript
- Start into web development again
  - Look at various wsgi frameworks
	- Started with web2py
	  - simple system
	  - unknown globals, among other things learned later took me away
	- looked at django and pyramid
	  - sqlalchemy major factor between both
	- looked at bottle and flask
	  - simple like pyramid, but too simple
  - Pyramid
	- pyramid is most flexible and easiest, it may look deceptively
	  simple, but it is full featured and powerful.
	- The pick and choose what you need was better choice for me.  The
	  goal was not to make a web site, or web application, but to make
	  a toolkit or framework that would make it easier to make a site
	  or application fairly quickly.
	
