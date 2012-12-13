ComplexresponseTells.Views.Tells ||= {}

class ComplexresponseTells.Views.Tells.TellView extends Backbone.View
  template: JST["backbone/templates/tell"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    console.log @model.toJSON()
    $(@el).html(@template(@model.toJSON() ))
    return this