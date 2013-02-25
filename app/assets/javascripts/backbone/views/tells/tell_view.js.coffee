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
    $('div', @el).css('display', 'initial')

  onOut: () ->
    $('div', @el).css('display', 'none')

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this
