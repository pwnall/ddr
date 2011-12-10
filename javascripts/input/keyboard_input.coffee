# Keyboard input interface.
class KeyboardInput
  @gamepads = {}
  
  @initialize: ->
    window.addEventListener 'MozGamepadConnected', @

  @_onConnect: (event) ->
    gamepad = event.gamepad
    @gamepads[gamepad.id] = gamepad
    console.log gamepad

  @_onDisconnect: (event) ->
    gamepad = event.gamepad
    delete @gamepads[gamepad.id]
    console.log ['removed', gamepad]

GamepadInput.initialize()
