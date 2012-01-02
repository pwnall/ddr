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
    if event.key
      button = event.key.toLowerCase()
    else if event.keyIdentifier and event.keyIdentifier.substring(0, 2) != 'U+'
      button = event.keyIdentifier.toUpperCase()
    else
      button = String.fromCharCode(event.keyCode).toUpperCase()
      if button == ' '
        button = 'SPACE'
        
    event = { device: @name, button: button, buttonDown: isKeyDown }
    @sink.onInput event
    
BootLdr.initializer 'controls_keyboard', ['controls_base'], ->
  Controls.addInput new KeyboardInput
BootLdr.dependsOn 'controls_keyboard', 'controls_inputs'
