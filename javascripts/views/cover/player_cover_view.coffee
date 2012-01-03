# Shows the notes that the player must play.
class PlayerCoverView
  constructor: (@cover, @domRoot) ->
    @player = @cover.player
    @displayNotes = @cover.song.style.display[@cover.sheetIndex]
    @sheetNotes = (note.display for note in @cover.song.style.notes)
    @chords = @cover.song.chords
    
    # Note widths and heights are hard-coded to 100 units.
    @metrics = {
      trackPadding: 20,  # Padding for each vertical "track" for notes.
      beats: 4,  # Number of beats that fit on the sheet.
      beatHeight: 250,  # Height that a note travels during a beat.
    }

    @computeLayout()
    @createNoteSymbols()
    @renderGuides()
    
    @chordsWindow = new CoverChordsWindow @cover
    @chordSvgs = {}

  # Computes the note sheet layout and creates the root SVG element.      
  computeLayout: ->
    # The sheet gets one vertical track for each arrow. 
    width = @displayNotes.length * (100 + 2 * @metrics.trackPadding)
    @noteX = for displayNote, i in @displayNotes
      @metrics.trackPadding + i * (100 + 2 * @metrics.trackPadding)
    
    height = @metrics.beatHeight * @metrics.beats
    @svg = new Pwnvg @domRoot, 0, 0, width, height
    
  # Define SVG symbols for all notes.
  createNoteSymbols: ->
    @noteSymbols = []
    for displayNote in @displayNotes
      image = displayNote.image
      @noteSymbols[displayNote.display] = @svg.defs.
         symbol('note-' + displayNote.display).aspectRatio('none').
         viewBox(0, 0, image.width, image.height).width('100%').height('100%')
      @noteSymbols[displayNote.display].rawSvgElem image.svg
    
  # Draw the static "guide arrows".
  renderGuides: ->
    @guideNotes = for displayNote, i in @displayNotes
      @svg.use('#note-' + displayNote.display, @noteX[i], 0, 100, 100).
           id("player-#{@cover.stageIndex}-guide-#{i}")

  # Updates the view to reflect the change in the show's time.
  #
  # @param {Number} beat the (fractional) beat offset into the song's sheet
  setSongBeat: (beat) ->
    deadChords = @chordsWindow.removeChords beat - 1
    for chord in deadChords
      @chordSvgs[chord].remove()
      delete @chordSvgs[chord]
    
    newChords = @chordsWindow.addChords beat + @metrics.beats
    for chord in newChords
      newSvg = @svg.group()
      for note in @chords[chord].notes
        displayNote = @displayNotes[note].display
        newSvg.use('#note-' + displayNote, @noteX[displayNote], 0, 100, 100)
      @chordSvgs[chord] = newSvg

    for chord, svg of @chordSvgs
      svg.resetTransform().translate 0,
          (@chords[chord].startBeat - beat) * @metrics.beatHeight

  # Updates the view to reflect a player move.
  #
  # @param {Number} note the index of the note that is playing
  # @param {Boolean} noteStarted if true, the player started playing the note,
  #                              otherwise the player just stopped playing it
  addPlayedNote: (note, startedNote) ->
    svg = @guideNotes[@sheetNotes[note]]
    if startedNote
      svg.addClass 'playing'
    else
      svg.removeClass 'playing'
