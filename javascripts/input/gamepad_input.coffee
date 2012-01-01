# Gamepad input interface.
class GamepadInput
  constructor: ->
    @name = 'gamepad'
    
  start: ->
    window.addEventListener 'GamepadConnected', ((event) => @_onConnect event),
                            false
    window.addEventListener 'GamepadDisconnected',
                            ((event) => @_onDisconnect event), false
    window.addEventListener 'MozGamepadConnected',
                            ((event) => @_onConnect event), false
    window.addEventListener 'MozGamepadDisconnected',
                            ((event) => @_onDisconnect event), false

  _onConnect: (event) ->
    gamepad = event.gamepad
    @gamepads[gamepad.id] = gamepad
    console.log gamepad

  _onDisconnect: (event) ->
    gamepad = event.gamepad
    delete @gamepads[gamepad.id]
    console.log ['removed', gamepad]

BootLdr.initializer 'controls_gamepad', ['controls_base'], ->
  Controls.addInput new GamepadInput
BootLdr.dependsOn 'controls_gamepad', 'controls_inputs'
