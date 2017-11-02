
class Dashing.Op5servicesack extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
  @accessor 'unAckedCritical', ->
    @get('servicesackcritun') > 0 && (@get('servicesackwarnun') == 0)

  @accessor 'unAckedWarning', ->
    @get('servicesackwarnun') > 0

  @accessor 'allAckedCrit', ->
    (@get('servicesackwarnun') == 0) && (@get('servicesackcritun') == 0) && (@get('servicesackcrit') > 0)

  @accessor 'allAckedWarn', ->
    (@get('servicesackwarnun') == 0) && (@get('servicesackcritun') == 0) && (@get('servicesackwarn') > 0) && (@get('servicesackcrit') == 0)
