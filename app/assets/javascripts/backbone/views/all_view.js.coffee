ComplexresponseTells.Views ||= {}

class ComplexresponseTells.Views.AllView extends Backbone.View
  template: JST["backbone/templates/all"]

  lastDragX = 0
  messageCount = 0
  hiddenlMessages = []
  visibleMessages = []
  visibleText = ''
  direction = 0

  initialize: () ->
    console.log 'init view'
    $(@el).attr('id', 'HomeView')
    @options.tells.bind('reset', @addAll)
#    @addAll()

  addAll: () =>
    console.log 'addAll'
    @options.tells.each(@addOne)
    messageCount = hiddenlMessages.length - 1

    console.log "hiddenlMessages", hiddenlMessages
    console.log "visibleMessages", visibleMessages

  addOne: (tell) =>
    message = tell.toJSON().message
    hiddenlMessages.push message.split("")
    visibleMessages.push []
    console.log tell
    view = new ComplexresponseTells.Views.Tells.TellView({model : tell})
    @$("ul").append view.render().el

  startDrag: (e) =>
    lastDragX = e.offsetX
    $(@el).mousemove @drag
    $(window).mouseup @stopDrag

  stopDrag: (e) =>
    $(@el).unbind 'mousemove'
    $(window).unbind 'mouseup'

  drag: (e) =>
    if lastDragX < e.offsetX
      direction = 1
    else if lastDragX > e.offsetX
      direction = -1
    else if lastDragX == e.offsetX
      direction = 0

    @updateText()

    lastDragX = e.offsetX

  updateText: () =>

    if direction == -1
      if hiddenlMessages[messageCount].length == 0
        messageCount--
      currentChar = hiddenlMessages[messageCount].pop()
      visibleMessages[messageCount].unshift currentChar
      console.log 'pop char:', visibleMessages[messageCount].join('')
    else if direction == 1
      if visibleMessages[messageCount].length == 0
        messageCount++
      currentChar = visibleMessages[messageCount].shift()
      hiddenlMessages[messageCount].unshift currentChar
      console.log 'shift char:', visibleMessages[messageCount].join('')

  render: =>
    console.log @options.tells.toJSON()
    $(@el).html(@template(tells: @options.tells.toJSON() ))

    $(@el).mousedown @startDrag

    return this
