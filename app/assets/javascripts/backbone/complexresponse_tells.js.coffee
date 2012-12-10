#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.ComplexresponseTells =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  init: (options) ->

    ComplexresponseTells.options = options
    new ComplexresponseTells.Routers.TellsRouter(options)

    if !Backbone.history.started
      Backbone.history.start()
      Backbone.history.started = true
