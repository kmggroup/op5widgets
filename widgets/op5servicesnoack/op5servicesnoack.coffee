class Dashing.Op5servicesnoack extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
  @accessor 'anyCritical', ->
    @get('servicesnoackcrit') > 0

  @accessor 'anyWarning', ->
    @get('servicesnoackwarn') > 0
