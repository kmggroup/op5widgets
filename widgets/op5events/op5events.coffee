class Dashing.Op5events extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
  @accessor 'serviceCriticalNotAcked', ->
     r1 = !@get('eventsacked') && (@get('eventstate') == 'CRITICAL')
     #console.log('op5events r1 = ' + r1)
     r1

  @accessor 'serviceWarningNotAcked', ->
    r2 = !@get('eventsacked') && (@get('eventstate') == 'WARNING' )
    #console.log('op5events r2 = ' + r2)
    r2

  @accessor 'serviceAcked', ->
    r3 = @get('eventsacked')
    #console.log('op5events r3 = ' + r3)
    r3
