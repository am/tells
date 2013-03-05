ComplexresponseTells.Views ||= {}

class ComplexresponseTells.Views.HomeView extends Backbone.View
  template: JST["backbone/templates/home"]

  events:
    "submit #new-tell": "save",
    "click #read": "list"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  initialize: () ->
    $(@el).attr('id', 'HomeView')

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (tell) =>
        @model = tell
        window.location.hash = "/all"

      error: (tell, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  list: (e) ->
    console.log e


  render: =>

    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    jQuery.get "/last.json", (data) =>
      $('.tell-last-word').text(data.word)

    return this