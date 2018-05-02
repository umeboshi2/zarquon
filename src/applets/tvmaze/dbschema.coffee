import Backbone from 'backbone'

import lf from 'lovefield'

# Use yaml to build schema
# https://groups.google.com/forum/#!topic/lovefield-users/jxIlb7jtiak

MainChannel = Backbone.Radio.channel 'global'

schemaBuilder = lf.schema.create('tvmaze-database', 13)

schemaBuilder.createTable('ShowObject')
.addColumn('id', lf.Type.INTEGER)
.addColumn('content', lf.Type.OBJECT)
.addPrimaryKey(['id'])

schemaBuilder.createTable('ShowEpisode')
.addColumn('id', lf.Type.INTEGER)
.addColumn('show_id', lf.Type.INTEGER)
.addColumn('content', lf.Type.OBJECT)
.addPrimaryKey(['id'])
.addIndex('show_index', ['show_id'], false, lf.Order.ASC)
.addForeignKey('fk_show_id',
  local: 'show_id'
  ref: 'ShowObject.id'
  action: lf.ConstraintAction.RESTRICT
  timing: lf.ConstraintTiming.IMMEDIATE
)

schemaBuilder.createTable('ShowGuid')
.addColumn('guid', lf.Type.STRING)
.addColumn('id', lf.Type.STRING)
.addColumn('content', lf.Type.STRING)
.addPrimaryKey(['guid'])


schemaBuilder.createTable('SimpleObject')
.addColumn('id', lf.Type.STRING)
.addColumn('content', lf.Type.STRING)
.addPrimaryKey(['id'])

schemaBuilder.createTable('TVMazeShow')
.addColumn('id', lf.Type.INTEGER)
.addColumn('name', lf.Type.STRING)
.addColumn('url', lf.Type.STRING)
.addColumn('self', lf.Type.STRING)
.addColumn('premiered', lf.Type.DATE_TIME)
.addColumn('runtime', lf.Type.INTEGER)
.addColumn('network_name', lf.Type.STRING)
.addColumn('imdb', lf.Type.STRING)
.addColumn('status', lf.Type.STRING)
.addColumn('summary', lf.Type.STRING)
.addColumn('img_med', lf.Type.STRING)
.addColumn('img_orig', lf.Type.STRING)
.addColumn('content', lf.Type.OBJECT)
.addPrimaryKey(['id'])
.addIndex('nameShowIdx', ['name'], false, lf.Order.ASC)



schemaBuilder.createTable('TVMazeEpisode')
.addColumn('id', lf.Type.INTEGER)
.addColumn('show_id', lf.Type.INTEGER)
.addColumn('name', lf.Type.STRING)
.addColumn('url', lf.Type.STRING)
.addColumn('self', lf.Type.STRING)
.addColumn('season', lf.Type.INTEGER)
.addColumn('number', lf.Type.INTEGER)
.addColumn('airdate', lf.Type.DATE_TIME)
.addColumn('airtime', lf.Type.STRING)
.addColumn('runtime', lf.Type.INTEGER)
.addColumn('summary', lf.Type.STRING)
.addColumn('img_med', lf.Type.STRING)
.addColumn('img_orig', lf.Type.STRING)
.addColumn('content', lf.Type.OBJECT)
.addPrimaryKey(['id'])
.addIndex('nameShowEpisodeIdx', ['name'], false, lf.Order.ASC)
.addIndex('airdateIdx', ['airdate'], false, lf.Order.ASC)
.addIndex('episodeShowIdx', ['show_id'], false, lf.Order.ASC)
.addForeignKey('fk_tvmaze_show_id',
  local: 'show_id'
  ref: 'TVMazeShow.id'
  action: lf.ConstraintAction.RESTRICT
  timing: lf.ConstraintTiming.IMMEDIATE
)

export default schemaBuilder

