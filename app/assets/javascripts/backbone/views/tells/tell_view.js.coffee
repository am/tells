ComplexresponseTells.Views.Tells ||= {}

class ComplexresponseTells.Views.Tells.TellView extends Backbone.View
  template: JST["backbone/templates/tells/tell"]

  events:
    "click .destroy" : "destroy"
    "mouseover" : "onOver"
    "mouseout" : "onOut"

  tagName: "li"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  onOver: () ->
    $(@el).css('opacity', '.5')

  onOut: () ->
    $(@el).css('opacity', '1')

  render: ->
    console.log @model.toJSON()
    $(@el).html(@template(@model.toJSON() ))
    return this
