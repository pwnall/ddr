# Gamepad input interface.
class GamepadInput
  # Creates a gamepad input source. Only one instance should be created.
  constructor: ->
    @name = 'gamepad'
    @sink = null  # Filled in by setSink() 
    
  # Sets the receiver of all input events.
  setSink: (@sink) ->
    null
    
  # Hooks into the game pad events and dispatches them to the sink.
  start: ->
    throw new Error "No event sink set" unless @sink
        
    window.addEventListener 'GamepadConnected', ((event) => @_onConnect event),
                            false
    window.addEventListener 'GamepadDisconnected',
                            ((event) => @_onDisconnect event), false
    window.addEventListener 'MozGamepadConnected',
                            ((event) => @_onConnect event), false
    window.addEventListener 'MozGamepadDisconnected',
                            ((event) => @_onDisconnect event), false

  # Called when a game pad is connected to the computer. 
  _onConnect: (event) ->
    gamepad = event.gamepad
    @gamepads[gamepad.id] = gamepad
    console.log gamepad

  # Called when a game pad is disconnected from the computer.
  _onDisconnect: (event) ->
    gamepad = event.gamepad
    delete @gamepads[gamepad.id]
    console.log ['removed', gamepad]

BootLdr.initializer 'controls_gamepad', ['controls_base'], ->
  Controls.addInput new GamepadInput
BootLdr.dependsOn 'controls_gamepad', 'controls_inputs'
