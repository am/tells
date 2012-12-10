ComplexresponseTells.Views.Tells ||= {}

class ComplexresponseTells.Views.Tells.IndexView extends Backbone.View
  template: JST["backbone/templates/tells/index"]

  initialize: () ->
    @options.tells.bind('reset', @addAll)

  addAll: () =>
    @options.tells.each(@addOne)

  addOne: (tell) =>
    view = new ComplexresponseTells.Views.Tells.TellView({model : tell})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(tells: @options.tells.toJSON() ))
    @addAll()

    return this
