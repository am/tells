class ComplexresponseTells.Routers.TellsRouter extends Backbone.Router
  initialize: (options) ->
    @tells = new ComplexresponseTells.Collections.TellsCollection()
    @tells.reset options.tells

  routes:
    "new"      : "newTell"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newTell: ->
    @view = new ComplexresponseTells.Views.Tells.NewView(collection: @tells)
    $("body").html(@view.render().el)

  index: ->
    # list all words
    @view = new ComplexresponseTells.Views.ReadView(tells: @tells)
    $("#read").html(@view.render().el)
    @tells.reset @tells.toJSON()

    # input
    @view = new ComplexresponseTells.Views.WriteView(collection: @tells)
    $("#write").html(@view.render().el)

  show: (id) ->
    tell = @tells.get(id)

    @view = new ComplexresponseTells.Views.Tells.ShowView(model: tell)
    $("#tells").html(@view.render().el)

  edit: (id) ->
    tell = @tells.get(id)

    @view = new ComplexresponseTells.Views.Tells.EditView(model: tell)
    $("#tells").html(@view.render().el)
