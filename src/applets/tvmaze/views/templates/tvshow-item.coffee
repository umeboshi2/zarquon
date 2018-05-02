tc = require 'teacup'
marked = require 'marked'

noImage = require('tbirds/templates/no-image-span').default

divStyle = 'width:20%;border-style:solid;border-width:3px'
cardClasses = 'col-md-3.bg-body-d5'

itemTemplate = tc.renderable (model) ->
  divStyle = model.divStyle or divStyle
  cardClasses = model.cardClasses or cardClasses
  viewLink = "#tvmaze/view/show/#{model.id}"
  itemBtn = '.btn.btn-sm'
  tc.div ".show-item.card.#{cardClasses}", style:divStyle, ->
    tc.div '.card-header', ->
      tc.strong '.card-title', model?.content?.name
    tc.div '.card-block', ->
      tc.a href:viewLink, ->
        img = model.content?.image?.medium
        if img
          tc.img '.card-img-bottom',
          src:model.content?.image?.medium,
          #style:'width:50%;height:50%'
        else
          noImage '4x'

module.exports = itemTemplate


