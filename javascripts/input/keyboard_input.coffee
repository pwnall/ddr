# Keyboard input interface.
class KeyboardInput
  constructor: ->
    window.addEventListener 'keydown', ((event) => @_onKeyDown event), false
    window.addEventListener 'keyup', ((event) => @_onKeyUp event), false

  _onKeyDown: (event) ->
    key = event.key

  _onKeyUp: (event) ->
    key = event.key

  @initialize: ->
    @instance = new GamepadInput

KeyboardInput.initialize()
