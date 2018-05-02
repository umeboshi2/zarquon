import $ from 'jquery'
import Backbone from 'backbone'
import { LoveStore } from 'backbone.lovefield'
import PageableCollection from 'backbone.paginator'

MainChannel = Backbone.Radio.channel 'global'
AppChannel = Backbone.Radio.channel 'usgov'

dbConn = MainChannel.request 'main:app:dbConn', 'usgov'

RoleStore = new LoveStore dbConn, 'Role'

class LocalRole extends Backbone.Model
  loveStore: RoleStore

class LocalRoleCollection extends Backbone.Collection
  loveStore: RoleStore
  model: LocalRole

local_roles = new LocalRoleCollection

AppChannel.reply 'get_local_roles', ->
  return local_roles
AppChannel.reply 'get-role-model', ->
  return LocalRole
AppChannel.reply 'get-role-collection', ->
  return LocalRoleCollection

baseURL = "https://www.govtrack.us/api/v2"

class UsGovRoles extends PageableCollection
  mode: 'server'
  full: true
  baseURL: baseURL
  url: ->
    return "#{baseURL}/role?current=true"

  fetcher: (options) ->
    options = options or {}
    currentPage = @state.currentPage
    offset = currentPage * @state.pageSize
    options.offset = offset
    options.dataType = 'jsonp'
    super options

  parse: (response) ->
    console.log "parse(response)", response
    @state.pageSize = response.meta.limit
    @state.totalRecords = response.meta.total_count
    @state.totalPages = Math.ceil @state.totalRecords / @state.pageSize
    # subtract one since firstPage is zero
    @state.lastPage = @state.totalPages - 1
    console.log "@state.totalRecords", @state.totalRecords, @state.totalPages
    super response.objects
    
  state:
    firstPage: 0
    pageSize: 20
    
  queryParams:
    pageSize: 'limit'
    offset: ->
      @state.currentPage * @state.pageSize
    currentPage: 'offset'
      
roles_collection = new UsGovRoles
AppChannel.reply 'get-roles-collection', ->
  return roles_collection
  
