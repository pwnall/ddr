# Information about all the inputs in the game.
class ControlsClass
  # Creates the game's control center.
  #
  constructor: ->
    @reset()

  # Parses the game's control information from a JSON object.
  #
  # @param {Object} jsonSchema JSON object describing the game's controls
  setSchema: (jsonSchema) ->
    @reset()
    @loadSchema jsonSchema

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
  
  # Registers a source of input signals.
  addInput: (driver) ->
    
  
  # Extends the control bindings table with the bindings in a JSON object.   
  addBindings: (jsonBindings) ->
    for jsonBinding in jsonBindings
      null

  # Resets all control information.
  reset: ->
    @globalSchema = []
    @playerSchema = []
    @controlTexts = {}

    @bindings = []
    
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
