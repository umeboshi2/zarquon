fs = require 'fs'
path = require 'path'

_ = require 'underscore'
Promise = require 'bluebird'
express = require 'express'

asyncfun = require 'asyncawait/async'
awaitfun = require 'asyncawait/await'
thumb = require('node-thumbnail').thumb

PHOTODIR = "#{process.env.OPENSHIFT_DATA_DIR}uploads"
if !fs.existsSync PHOTODIR
  fs.mkdirSync PHOTODIR
THUMBDIR = "#{process.env.OPENSHIFT_DATA_DIR}thumbs"
if !fs.existsSync THUMBDIR
  fs.mkdirSync THUMBDIR
ThumbData =
  source: PHOTODIR
  destination: THUMBDIR
  width: 150
  suffix: ''

router = express.Router()


multer = require 'multer'
storage = multer.diskStorage
  destination: (req, file, cb) ->
    cb null, PHOTODIR
  filename: (req, file, cb) ->
    cb null, file.originalname
    
upload = multer
  #dest: 'uploads/'
  storage: storage
{ get_models } = require './common'


#router.use hasUserAuth

router.get '/all-models', (req, res) ->
  get_models req, res
  .then ->
    res.json res.locals.models

router.post '/upload-photo',
upload.single('comicphoto'), asyncfun (req, res) ->
  data =
    comic_id: req.body.comic_id
    name: req.body.name
    filename: req.file.filename
    encoding: req.file.encoding
    mimetype: req.file.mimetype
  model = new res.app.locals.bsmodels.comicphoto data
  model.save()
  .then (result) ->
    # successful create gets a 201 status
    res.status 201
    # and a location header pointing to new object
    res.header 'Location', "/fake/path/to/#{result.id}"
    res.json result
  # FIXME
  # this promise doesn't go anywhere
  tp = thumb ThumbData

router.delete '/delete-photo/:id', (req, res) ->
  model = new res.app.locals.bsmodels.comicphoto
    id: req.params.id
  model.fetch()
  .then (result) ->
    console.log "delete-photo", result
    tname = path.join THUMBDIR, result.get 'filename'
    pname = path.join PHOTODIR, result.get 'filename'
    fs.unlinkSync tname
    fs.unlinkSync pname
  .then ->
    model.destroy()
  .then (result) ->
    res.json result

router.post '/upload-photos', upload.array('comicphoto', 12), (req, res) ->
  console.log req.file
  model = new res.app.locals.bsmodels.uploads
  #res.app.locals.bsmodels.uploads.bulkCreate req.files
  #.then ->
  #  res.json
  #    result: 'success'
  #    data: req.
  console.log "FILES", req.files
  res.json result:'something happened'

router.get '/unattached-comics', asyncfun (req, res) ->
  knex = res.app.locals.knex
  wstable = 'ebcomics_workspace'
  ctable = 'ebcsv_clz_comics'
  wscomics = knex.select('comic_id').from(wstable)
  comics = knex.select().from(ctable).whereNotIn('comic_id', wscomics)
  totalClone = comics.clone()#.groupBy('comic_id')
  total = awaitfun totalClone.count('comic_id')
  console.log "total", total
  if req.query
    if req.query.sort or req.query.offset
      direction = req.query.direction or 'ASC'
      direction = direction.toLowerCase()
      if Array.isArray req.query.sort
        orderExpression = []
        req.query.sort.forEach (col) ->
          orderExpression.push "#{col} #{direction}"
        comics = comics.orderByRaw(orderExpression.join(', '))
      else
        comics = comics.orderBy(req.query.sort, direction)
    if req.query.offset
      comics = comics.offset(req.query.offset)
    if req.query.limit
      comics = comics.limit(req.query.limit)

  comics.then (results) ->
    if total.length
      total = total[0].count
    else
      total = 0
    data =
      total: total
      items: results
    res.json data
  

module.exports = router
