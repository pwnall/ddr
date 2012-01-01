# Triggers an event on every view redraw.
class RedrawInput
  # Creates a gamepad input source. Only one instance should be created.
  constructor: ->
    @name = 'vsync'
    @sink = null  # Filled in by setSink() 
    @started = false
    @raf = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
           window.webkitRequestAnimationFrame
    @handler = ((time) => @_onAnimationFrame time)
    
  # Sets the receiver of all input events.
  setSink: (@sink) ->
    null
    
  # Hooks into the redraw events and dispatches them to the sink.
  start: ->
    throw new Error "No event sink set" unless @sink

    @started = true
    # HACK(pwnall): should use @raf
    @raf.call window, @handler
    
  # Stops dispatching redraw events to the sink, unhooks from them asap.
  stop: ->
    @started = false
    
  # Called by requestAnimationFrame.
  _onAnimationFrame: (time) ->
    return unless @started
    @sink.onInput { device: @name, time: time }
    # NOTE: checking @started again, because of event handlers
    @raf.call window, @handler if @started

BootLdr.initializer 'controls_vsync', ['controls_base'], ->
  Controls.addInput new RedrawInput
BootLdr.dependsOn 'controls_vsync', 'controls_inputs'
