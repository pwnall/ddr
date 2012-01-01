# Information about all the inputs in the game.
class Controls
  # Creates the game's control center.
  #
  constructor: ->
    @reset()

  # Parses the game's control information from a JSON object.
  #
  # @param {Object} controlSchema JSON object describing the game's controls
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
    
# Controls is a singleton.
Controls.s = new Controls
    

# JSON array listing the key bindings in the game.
bindings = [
  {
    'control': 'start',    
    'device': 'keyboard',
    'button': '\\',
    'player': null
  },
  {
    'control': 'pause',
    'device': 'keyboard',
    'button': ' ',
    'player': null
  },
  {
    'control': 'up',
    'device': 'keyboard',
    'button': 'w',
    'player': 0
  },
  {
    'control': 'down',
    'device': 'keyboard',
    'button': 's',
    'player': 0
  },
  {
    'control': 'left',
    'device': 'keyboard',
    'button': 'a',
    'player': 0
  },
  {
    'control': 'right',
    'device': 'keyboard',
    'button': 'd',
    'player': 0
  },
  {
    'control': 'up',
    'device': 'keyboard',
    'button': 'i',
    'player': 1
  },
  {
    'control': 'down',
    'device': 'keyboard',
    'button': 'k',
    'player': 1
  },
  {
    'control': 'left',
    'device': 'keyboard',
    'button': 'j',
    'player': 1
  },
  {
    'control': 'right',
    'device': 'keyboard',
    'button': 'l',
    'player': 1
  }
]
