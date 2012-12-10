ComplexresponseTells.Views.Tells ||= {}

class ComplexresponseTells.Views.Tells.NewView extends Backbone.View
  template: JST["backbone/templates/tells/new"]

  events:
    "submit #new-tell": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (tell) =>
        @model = tell
        window.location.hash = "/#{@model.id}"

      error: (tell, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
