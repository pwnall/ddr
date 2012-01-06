# A player's cover (performance) of a song.
class Cover
  # Creates a cover.
  #
  # @param {Player} player the identity of the performer
  # @param {Number} sheetIndex the group of notes followed by the player in the
  #                            song's sheet; for example, all players follow
  #                            group 0 in dance-single sheets
  # @param {Number} stageIndex the player's unique position on the show's stage
  # @param {Song} song the song being covered
  constructor: (@player, @sheetIndex, @stageIndex, @song) ->
    @scoringRules = {
      tap: [
        { minDelay: -0.125, maxDelay: 0.25, text: 'Boo', id: 'boo' },
        { minDelay: -0.0625, maxDelay: 0.125, text: 'Ok', id: 'ok' },
        { minDelay: -0.03125, maxDelay: 0.0625, text: 'Great', id: 'great' },
        { minDelay: -0.015625, maxDelay: 0.03125, text: 'Perfect', id: 'perfect' },
        { minDelay: -0.0078125, maxDelay: 0.015625, text: 'Flawless', id: 'flawless' }
      ],
      hold: [
        { text: 'OK', id: 'boo' },
        { text: 'NG', id: 'ok' }
      ],
      miss: { text: 'Miss', id: 'miss' }
    }
    @scoringWindowLowOffset = -@scoringRules.tap[0].minDelay
    @scoringWindowHiOffset = -@scoringRules.tap[0].maxDelay 
    
    @metadata = {
      difficulty: {
        steps: @song.metadata.sheet.difficulty.steps,
        radar: @song.metadata.sheet.difficulty.radar
      },
      style: @song.metadata.sheet.style
    }

    @activeNotes = {}
    for noteData, index in @song.style.notes
      @activeNotes[index] = null

    @playedNotes = []
    @chordsWindow = new CoverChordsWindow @
    @chords = @song.chords
    @scores = (null for chord in @chords)
    @scoreChanges = []
    
  
  # Updates the show's time offset.
  #
  # @param {Number} beat the (fractional) beat offset into the song's sheet
  setSongBeat: (@beat) ->
    newChords = @chordsWindow.addChords @beat + @scoringWindowLowOffset
    deadChords = @chordsWindow.removeChords @beat + @scoringWindowHiOffset
    for chordIndex in deadChords
      unless @scores[chordIndex]
        @setChordScore @chords[chordIndex], @scoringRules.miss

  # Updates the cover and score history with a player move.
  playedNote: (note, noteStarted) ->
    if noteStarted
      # Started playing a note.
      playedNote = { note: note, startedAt: @beat, chord: null }
      @playedNotes.push playedNote
      @activeNotes[note] = playedNote
      
      chord = @scorableChord()
      @scoreChord chord unless chord is null
    else
      # Stopped playing a note.
      playedNote = @activeNotes[note]
      @activeNotes[note] = null
      playedNote.stoppedAt = @beat      
  
  # Finds the best chord to be associated with the currently playing notes.
  scorableChord: ->
    upperLimit = @scoringRules.tap[0].maxDelay
    lowerLimit = @scoringRules.tap[0].minDelay
    bestScore = lowerLimit - 0.00001
    bestChord = null
    for chordIndex in @chordsWindow.chords()
      continue unless @scores[chordIndex] is null

      chord = @chords[chordIndex]
      chordScore = bestScore
      for note in chord.notes
        playedNote = @activeNotes[note]
        if playedNote is null or playedNote.chord
          chordScore = bestScore
          break
        delay = playedNote.startedAt - chord.startBeat
        chordScore = delay if delay > chordScore
      if chordScore != bestScore and chordScore <= upperLimit
        bestScore = chordScore
        bestChord = chord
    bestChord

  # Modifies a chord's scores to account for the currently playing notes.
  scoreChord: (chord) ->
    rules = @scoringRules.tap
    ruleIndex = rules.length - 1
    for note in chord.notes
      playedNote = @activeNotes[note]
      playedNote.chord = chord
      delay = playedNote.startedAt - chord.startBeat
      while ruleIndex > 0
        if rules[ruleIndex].minDelay <= delay <= rules[ruleIndex].maxDelay 
          break
        ruleIndex -= 1
    @setChordScore chord, rules[ruleIndex]

  # Assigns an already computed score to a chord.
  setChordScore: (chord, score) ->
    @scores[chord.index] = score
    @scoreChanges.push chord.index
