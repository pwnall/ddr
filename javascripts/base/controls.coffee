# Information about all the inputs in the game.
class ControlsClass
  # Creates the game's control center.
  constructor: ->
    @devices = {}
    @listeners = {global: [], tick: []}
    @reset()

  # Initializes or replaces the game's control information.
  #
  # @param {Object} jsonSchema JSON object describing the game's controls
  setSchema: (jsonSchema) ->
    @reset()
    @loadSchema jsonSchema

  # Extends the control bindings table with the bindings in a JSON object.   
  addBindings: (jsonBindings) ->
    for jsonBinding in jsonBindings
      binding = { action: jsonBindings.action }

      if jsonBinding.player
        binding.player = jsonBinding.player 
      else
        binding.player = 'global'
      
      device = jsonBinding.device
      button = jsonBinding.button.toLowerCase()
      @bindings[device] ||= {}
      @bindings[device][button] = binding

  # Registers a source of input signals.
  addInput: (device) ->
    if @devices[device.name]
      throw new Error "Already added input source #{name}"

    @devices[device.name] = device
    @bindings[device.name] ||= {}
    device.setSink @
    device.start()

  # Adds a listener to be called on every redraw event.
  #
  # @param {String, Number} player either a player number, or one of the strings
  #     'global' (events with no specific player) and 'tick' (timer)
  # @param {Function<Number>} listener will be called on every redraw event
  addListener: (player, listener) ->
    @listeners[player] ||= []
    @listeners[player].push listener
  
  # Parses the game's control information from a JSON object.
  #
  # @param {Object} jsonSchema JSON object describing the game's controls
  loadSchema: (jsonSchema) ->
    for jsonControl in jsonSchema
      id = jsonControl.id
      if @controlTexts[id]
        throw new Error "Duplicate id #{id} in control schema"
      @controlTexts[id] = jsonControl.text
      schema = if jsonControl.global then @globalSchema else @playerSchema
      control = { index: schema.length, id: id, data: jsonControl.global }
    
  # Processes an input event and routes it.
  onInput: (event) ->
    return unless binding = @bindings[event.device][event.button]
    # TODO(pwnall): update control state
    @_callListeners @listeners[binding.player], event

  # Processes a timer tick event and routes it.
  onTick: (event) ->
    @_callListeners @listeners['tick'], event
    
  # Resets all control information.
  reset: ->
    @globalSchema = []
    @playerSchema = []
    @controlTexts = {}

    @bindings = {}
    for name, device of @devices
      @bindings[name] = {}
    null

  # Calls a sequence of listeners.
  _callListeners: (listenerArray, event) ->
    return unless listenerArray
    for listener in listenerArray
      listener event
    null
    
Controls = null  # Filled in by initializer.
BootLdr.initializer 'controls_base', [], ->
  Controls = new ControlsClass  # Singleton.
  window.Controls = Controls  # Export.

# Dummy initializer meaning that all the inputs have been registered.  
BootLdr.initializer 'controls_inputs', ['controls_base', 'dom_load'], -> null
# Dummy initializer meaning that the input subsystem is ready.
BootLdr.initializer 'controls', ['controls_bindings'], -> null

# Callback for the bindings JSONP data.
window.onControlBindings = (jsonBindings) ->
  BootLdr.initializer 'controls_bindings', ['controls_schema',
      'controls_inputs'], -> Controls.addBindings jsonBindings
