# Keyboard input interface.
class KeyboardInput
  constructor: ->
    @name = 'keyboard'
    
  start: ->
    window.addEventListener 'keydown', ((event) => @_onKeyDown event), false
    window.addEventListener 'keyup', ((event) => @_onKeyUp event), false

  _onKeyDown: (event) ->
    key = event.key

  _onKeyUp: (event) ->
    key = event.key
    
BootLdr.initializer 'controls_keyboard', ['controls_base'], ->
  Controls.addInput new KeyboardInput
BootLdr.dependsOn 'controls_keyboard', 'controls_inputs'
