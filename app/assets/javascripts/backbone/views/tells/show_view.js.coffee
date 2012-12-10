ComplexresponseTells.Views.Tells ||= {}

class ComplexresponseTells.Views.Tells.ShowView extends Backbone.View
  template: JST["backbone/templates/tells/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
