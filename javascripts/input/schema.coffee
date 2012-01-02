BootLdr.initializer 'controls_schema', ['controls_base'], ->
  # JSON array listing the controls in this game.
  controlSchema = [
    {
      'id': 'start',
      'text': 'Start Game',
      'global': true
    },
    {
      'id': 'pause',
      'text': 'Pause Game',
      'global': true
    },
    {
      'id': 'left',
      'text': 'Left',
      'global': false,
      'data': { 'note': 0 }
    },
    {
      'id': 'right', 
      'text': 'Right',
      'global': false,
      'data': { 'note': 3 }
    },
    {
      'id': 'up',
      'text': 'Up',
      'global': false,
      'data': { 'note': 1 }
    },
    {
      'id': 'down',
      'text': 'Down',
      'global': false,
      'data': { 'note': 2 }
    }
  ]
  Controls.setSchema controlSchema
