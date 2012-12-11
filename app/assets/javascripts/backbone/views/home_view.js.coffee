ComplexresponseTells.Views ||= {}

class ComplexresponseTells.Views.HomeView extends Backbone.View
  template: JST["backbone/templates/home"]

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


    jQuery.get "/last.json", (data) =>
      console.log data
      $('#lastWord').text(data.word)

    return this
