# Calls listeners periodically, to redraw the views.
class RedrawInput
  constructor: ->
    @listeners = []
    @started = false
    @raf = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
           window.webkitRequestAnimationFrame
    @handler = ((time) => @onAnimationFrame time)
  
  # Starts calling listeners periodically.
  start: ->
    return if @started
    @started = true
    @raf @handler
    
  # Stops calling listeners periodically.
  stop: ->
    return unless @started
    @started = false
    
  # Adds a listener to be called on every redraw event.
  #
  # @param [function<Number>] listener will be called on every redraw event
  addListener: (listener) ->
    @listeners.push @listener
    
  # Removes all the redraw event listeners.
  clearListeners: ->
    @listeners = []
  
  # Called by requestAnimationFrame.
  onAnimationFrame: (time) ->
    return unless @started
    for listener in @listeners
      listener time
    # NOTE: checking @started again, because of event handlers
    @raf @handler if @started

  @initialize: ->
    @instance = new GamepadInput

RedrawInput.initialize()
