import Backbone from 'backbone'

import lf from 'lovefield'

# Use yaml to build schema
# https://groups.google.com/forum/#!topic/lovefield-users/jxIlb7jtiak

MainChannel = Backbone.Radio.channel 'global'

schemaBuilder = lf.schema.create('ebcsv-database', 2)

schemaBuilder.createTable('Config')
.addColumn('id', lf.Type.STRING)
.addColumn('name', lf.Type.STRING)
.addColumn('content', lf.Type.OBJECT)
.addPrimaryKey(['id'])

schemaBuilder.createTable('Description')
.addColumn('id', lf.Type.STRING)
.addColumn('name', lf.Type.STRING)
.addColumn('title', lf.Type.STRING)
.addColumn('content', lf.Type.STRING)
.addPrimaryKey(['id'])

schemaBuilder.createTable('ComicUrl')
.addColumn('url', lf.Type.STRING)
.addColumn('image_src', lf.Type.STRING)
.addPrimaryKey(['url'])

export default schemaBuilder

