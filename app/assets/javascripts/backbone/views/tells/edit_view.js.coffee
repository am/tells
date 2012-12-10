ComplexresponseTells.Views.Tells ||= {}

class ComplexresponseTells.Views.Tells.EditView extends Backbone.View
  template : JST["backbone/templates/tells/edit"]

  events :
    "submit #edit-tell" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (tell) =>
        @model = tell
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
