# Keyboard input interface.
class KeyboardInput
  # Creates a keyboard input source. Only one instance should be created.
  constructor: ->
    @name = 'keyboard'
    @sink = null  # Filled in by setSink() 
    
  # Sets the receiver of all input events.
  setSink: (@sink) ->
    null
    
  # Hooks into the keyboard events and dispatches them to the sink.
  start: ->
    throw new Error "No event sink set" unless @sink
    
    window.addEventListener 'keydown', ((event) => @_onKeyDown event), false
    window.addEventListener 'keyup', ((event) => @_onKeyUp event), false

  # Called when a key is pressed. (keydown DOM event)
  _onKeyDown: (event) ->
    @_onKey event, true

  # Called when a key is released. (keyup DOM event)
  _onKeyUp: (event) ->
    @_onKey event, false
    
  # Creates and dispatches a key input event.
  _onKey: (event, isKeyDown) ->
    event = { device: @name, button: event.key, buttonDown: isKeyDown }
    @sink.onEvent 
    
BootLdr.initializer 'controls_keyboard', ['controls_base'], ->
  Controls.addInput new KeyboardInput
BootLdr.dependsOn 'controls_keyboard', 'controls_inputs'
