ComplexresponseTells.Views ||= {}

class ComplexresponseTells.Views.ReadView extends Backbone.View
  template: JST["backbone/templates/read"]

  lastDragX = 0
  messageCount = 0
  hiddenlMessages = []
  visibleMessages = []
  visibleText = ''
  direction = 0
  container = null

  initialize: () ->
    $(@el).attr('id', 'HomeView')
    @options.tells.bind('reset', @addAll)

#    $('.pulley').draggable()

  addAll: () =>
    container = @$('#tells-list>ul')
    @options.tells.each(@addOne)
    messageCount = hiddenlMessages.length - 1

  addOne: (tell) =>
    message = tell.toJSON().message
    hiddenlMessages.push message.split("")
    visibleMessages.push []
    view = new ComplexresponseTells.Views.Tells.TellView({model: tell})
#    container.append '<li><p></p></li>'
#    console.log view
#    container.append view.render()
    container.append(view.render().el)

  startDrag: (e) =>
    lastDragX = e.offsetX
    $(window).mousemove @drag
    $(window).mouseup @stopDrag

  stopDrag: (e) =>
    $(window).unbind 'mousemove'
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
    # ------------------------------ add chars
    if direction == 1

      if messageCount is 0 and hiddenlMessages[messageCount].length is 0
        return
      if hiddenlMessages[messageCount].length == 0
        messageCount--

      currentChar = hiddenlMessages[messageCount].pop()
      visibleMessages[messageCount].unshift currentChar

      $($('li>p', container)[messageCount]).html visibleMessages[messageCount].join('')


    # ------------------------------ remove chars
    else if direction == -1
      # no more chars to remove
      if messageCount is visibleMessages.length - 1 and visibleMessages[messageCount].length == 0
        return
      # skip to next phrase
      if messageCount < visibleMessages.length and visibleMessages[messageCount].length == 0
        messageCount++

      currentChar = visibleMessages[messageCount].shift()
      hiddenlMessages[messageCount].push currentChar

      $($('li>p', container)[messageCount]).html visibleMessages[messageCount].join('')


  render: =>
    $(@el).html(@template(tells: @options.tells.toJSON()))
    $(@el).mousedown @startDrag
    return this
