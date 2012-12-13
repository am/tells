ComplexresponseTells.Views ||= {}

class ComplexresponseTells.Views.AllView extends Backbone.View
  template: JST["backbone/templates/all"]

  initialize: () ->
    console.log 'init view'
    $(@el).attr('id', 'HomeView')
    @options.tells.bind('reset', @addAll)
#    @addAll()

  addAll: () =>
    console.log 'addAll'
    @options.tells.each(@addOne)

  addOne: (tell) =>
    console.log tell
    view = new ComplexresponseTells.Views.Tells.TellView({model : tell})
    @$("tbody").append(view.render().el)

  render: =>
    console.log @options.tells.toJSON()
    $(@el).html(@template(tells: @options.tells.toJSON() ))

    return this
