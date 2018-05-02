bookshelf = require './bookshelf'
MODELS = {}

clzcollectionstatus = bookshelf.Model.extend
  tableName: 'clz_collection_status'
MODELS.clzcollectionstatus = clzcollectionstatus

ebclzcomic = bookshelf.Model.extend
  tableName: 'ebcsv_clz_comics'
  hasTimestamps: true
  collectionStatus: ->
    @belongsTo clzcollectionstatus, 'list_id'
  photos: ->
    @hasMany comicphoto, 'comic_id', 'comic_id'
  workspace: ->
    @hasOne MODELS.ebcomicworkspace, 'comic_id', 'comic_id'
,
  jsonColumns: ['content']
MODELS.ebclzcomic = ebclzcomic

ebclzpage = bookshelf.Model.extend
  tableName: 'ebcsv_clz_comic_pages'
,
  jsonColumns: ['clzdata']
MODELS.ebclzpage = ebclzpage

ebcomicworkspace = bookshelf.Model.extend
  tableName: 'ebcomics_workspace'
  hasTimestamps: true
  comic: ->
    @belongsTo ebclzcomic, 'comic_id', 'comic_id'
MODELS.ebcomicworkspace = ebcomicworkspace

ebcsvcfg = bookshelf.Model.extend
  tableName: 'ebcsv_configs'
  hasTimestamps: true
,
  jsonColumns: ['content']
MODELS.ebcsvcfg = ebcsvcfg
  
ebcsvdsc = bookshelf.Model.extend
  tableName: 'ebcsv_descriptions'
  hasTimestamps: true
MODELS.ebcsvdsc = ebcsvdsc

fhtodos = bookshelf.Model.extend
  tableName: 'flathead_todos'
  hasTimestamps: true
MODELS.fhtodos = fhtodos

uploads = bookshelf.Model.extend
  tableName: 'general_uploads'
  hasTimestamps: true
MODELS.uploads = uploads

comicphoto = bookshelf.Model.extend
  tableName: 'comic_photos'
  hasTimestamps: true
  comic: ->
    @belongsTo ebclzcomic, 'comic_id', 'comic_id'
MODELS.comicphoto = comicphoto
  
comicphotoname = bookshelf.Model.extend
  tableName: 'comic_photo_names'
  hasTimestamps: false
MODELS.comicphotoname = comicphotoname
  
yadayada = bookshelf.Model.extend
  tableName: 'flathead_todos'
  hasTimestamps: true
MODELS.yadayada = yadayada



module.exports = MODELS
