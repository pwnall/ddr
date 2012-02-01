# WebKit Gamepad input interface.
class WebkitGamepadInput
  # Creates a gamepad input source. Only one instance should be created.
  constructor: ->
    @name = 'webkitGamepad'
    @sink = null  # Filled in by setSink()
    @started = false
    @buttons = []
    @handler = => @_onTick()
    @tickResolution = 10
    
  # Sets the receiver of all input events.
  setSink: (@sink) ->
    null
    
  # Hooks into the game pad events and dispatches them to the sink.
  start: ->
    @started = true
    @buttons = []
    return unless navigator.webkitGamepads
    window.setTimeout @handler, @tickResolution

  stop: ->
    @started = false

  # Polls for gamepad state.
  _onTick: ->
    return unless @started
    for pad, padIndex in navigator.webkitGamepads
      if pad
        if padButtons = @buttons[padIndex]
          # Check for gamepad state changes.
          for button, buttonIndex in pad.buttons
            if button != (padButtons[buttonIndex] || 0)
              @_onButton padIndex, buttonIndex, button == 1
          @buttons[padIndex] = pad.buttons[0..]
        else
          # Gamepad connected.
          @buttons[padIndex] = pad.buttons[0..]
      else
        # Gamepad disconnected.

    # NOTE: checking @started again, because of event handlers
    window.setTimeout @handler, @tickResolution if @started

  # Creates and dispatches a gamepad input event.
  _onButton: (padIndex, buttonIndex, isButtonDown) ->    
    event = { 
      device: "gamepad#{padIndex + 1}",
      button: (buttonIndex + 1).toString(),
      buttonDown: isButtonDown
    }
    @sink.onInput event
    

BootLdr.initializer 'controls_webkit_gamepad', ['controls_base'], ->
  Controls.addInput new WebkitGamepadInput
BootLdr.dependsOn 'controls_webkit_gamepad', 'controls_inputs'
