$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
lf = require 'lovefield'
moment = require 'moment'

FullCalendar = require 'fullcalendar'
require 'fullcalendar/dist/fullcalendar.css'

apiroot = '/foo/bar'

MainChannel = Backbone.Radio.channel 'global'
AppChannel = Backbone.Radio.channel 'tvmaze'

HubChannel = Backbone.Radio.channel 'hubby'

#################################
# templates
#################################

tc = require 'teacup'

episodeCalendar = tc.renderable () ->
  tc.div '.listview-header', 'Episodes'
  tc.div '.loading', ->
    tc.h2 ->
      tc.i '.fa.fa-spinner.fa-spin'
      tc.text 'Loading Episodes'
  tc.div '.maincalendar'

#################################

render_calendar_event = (calEvent, element) ->
  calEvent.url = "#tvmaze/shows/view/#{calEvent.showId}"
  element.css
    cursor: 'pointer'
    'font-size': '0.9em'
    'font-family': 'Rambla'
    
  
loading_calendar_events = (bool) ->
  loading = $ '.loading'
  header = $ '.fc-toolbar'
  if bool
    loading.show()
    header.hide()
  else
    loading.hide()
    header.show()

loading_test = (bool) ->
  console.log "loading_test", bool

getEpisodes = (start, end, timezone, cb) ->
  Model = AppChannel.request 'get-local-episode-model'
  Collection = AppChannel.request 'get-local-episode-collection'
  conn = MainChannel.request 'main:app:dbConn', 'tvmaze'
  table = conn.getSchema().table('TVMazeEpisode')
  filters = []
  window.startMoment = start
  startDate = start.toDate()
  endDate = end.toDate()
  filters.push table.airdate.gte(start)
  filters.push table.airdate.lte(end)
  q = conn.select().from(table)
  #.where(lf.op.and(filters))
  .where(lf.op.and( table.airdate.gte(start.toDate()),
    table.airdate.lte(end.toDate())))
  console.log "Q", q, startDate, endDate
  q = q.exec()
  console.log "Q", q
  q.then (results) ->
    console.log "RESULTS", results
    collection = new Collection
    collection.set results
    episodes = collection.toJSON()
    console.log "collection", collection
    events = []
    episodes.forEach (episode) ->
      airdate = moment(episode.airdate)
      # default to thirty minutes if no runtime
      runtime = episode.runtime or 30
      data =
        id: episode.id
        showId: episode.show_id
        title: episode.name
        allDay: false
        start: airdate
        end: airdate.add(runtime, 'minutes')
        url: "#tvmaze/shows/view/#{episode.show_id}"
      events.push data
    cb events
    
  
class EpisodeCalendarView extends Backbone.Marionette.View
  template: episodeCalendar
  ui:
    calendar: '.maincalendar'
    loading: '.loading'
    header: '.fc-toolbar'
    daytop: '.fc-day-top'
    
  options:
    minicalendar: false
    layout: false

  onBeforeDestroy: ->
    cal = @ui.calendar.fullCalendar 'destroy'
    console.log "calendar destroyed"

  calendarViewRender: (view, element) =>
    AppChannel.request 'maincalendar:set-date', @ui.calendar
    
  onDomRefresh: () ->
    calEventClick = (event) =>
      if not @options.minicalendar
        url = event.url
        console.log "EVENT URL", event, url
        Backbone.history.navigate url, trigger: true
      else
        options =
          layout: @options.layout
          region: 'episode'
          id: event.id

        AppChannel.request 'view-episode', options
    date = AppChannel.request 'maincalendar:get-date' or new Date()
    cal = @ui.calendar
    cal.fullCalendar
      defaultDate: date
      header:
        left: 'prevYear, nextYear'
        center: 'title'
        right: 'prev, next'
      theme: false
      defaultView: 'month'
      eventSources:[
        {
          events: getEpisodes
        }
      ]
      eventRender: render_calendar_event
      viewRender: @calendarViewRender
      loading: loading_calendar_events
      eventClick: calEventClick
    console.log "we should either be fetching events, or refetching"

    
module.exports = EpisodeCalendarView
  
