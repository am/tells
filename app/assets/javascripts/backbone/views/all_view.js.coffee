ComplexresponseTells.Views ||= {}

class ComplexresponseTells.Views.AllView extends Backbone.View
  template: JST["backbone/templates/all"]

  lastDragX = 0
  messageCount = 0
  hiddenlMessages = []
  visibleMessages = []
  visibleText = ''
  direction = 0
  container = null

  initialize: () ->
    console.log 'init view'
    $(@el).attr('id', 'HomeView')
    @options.tells.bind('reset', @addAll)
#    @addAll()

  addAll: () =>
    container = @$('#tells-list>ul')

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
#    @$("#tells-list>ul").append view.render().el

    container.append '<li></li>'


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

    # add chars
    if direction == 1

      if messageCount is 0 and hiddenlMessages[messageCount].length is 0
        return

      if hiddenlMessages[messageCount].length == 0
        messageCount--
      currentChar = hiddenlMessages[messageCount].pop()
      visibleMessages[messageCount].unshift currentChar

#      console.log 'remove this: ', visibleMessages[messageCount].join('')
      $($('li', container)[messageCount]).html visibleMessages[messageCount].join('')

      all = ''
      for i in [1..visibleMessages.length - messageCount] by 1
        all += visibleMessages[messageCount + (i-1)].join('')

      # render chars
#      container.html(all)

    # remove chars
    else if direction == -1
      # no more chars to remove
      if messageCount is visibleMessages.length - 1 and visibleMessages[messageCount].length == 0
        return
      # skip to next phrase
      if messageCount < visibleMessages.length and visibleMessages[messageCount].length == 0
        messageCount++

      currentChar = visibleMessages[messageCount].shift()
      hiddenlMessages[messageCount].unshift currentChar

#      console.log 'add this: ', visibleMessages[messageCount].join('')
      $($('li', container)[messageCount]).html visibleMessages[messageCount].join('')

      all = ''
      for i in [1..visibleMessages.length - messageCount] by 1
        all += visibleMessages[messageCount + (i-1)].join('')

    # render chars
#    $($('.tell', container)[messageCount]).html all
#    container.html(all)

  render: =>
    console.log @options.tells.toJSON()
    $(@el).html(@template(tells: @options.tells.toJSON() ))

    $(@el).mousedown @startDrag

    return this
