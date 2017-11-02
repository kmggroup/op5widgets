class Dashing.Op5hosts extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
  @accessor 'hostDown', ->
    @get('errhosts') > 0

  @accessor 'serviceDown', ->
    ((@get('errhosts') == 0) &&  (@get('servstathosts') > 0))

  redirect: ->
    link2 = @get('url')
    console.log("url:", link2)
    window.open(
      link2,
      '_blank'
    ); 