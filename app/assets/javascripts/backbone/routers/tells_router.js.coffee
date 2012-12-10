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
    $("#tells").html(@view.render().el)

  index: ->
    @view = new ComplexresponseTells.Views.Tells.IndexView(tells: @tells)
    $("#tells").html(@view.render().el)

  show: (id) ->
    tell = @tells.get(id)

    @view = new ComplexresponseTells.Views.Tells.ShowView(model: tell)
    $("#tells").html(@view.render().el)

  edit: (id) ->
    tell = @tells.get(id)

    @view = new ComplexresponseTells.Views.Tells.EditView(model: tell)
    $("#tells").html(@view.render().el)
