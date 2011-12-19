# Shows the notes that the player must play.
class PlayerControlsView
  constructor: (@show, @domRoot) ->
    @player = @show.player
    @displayNotes = @show.song.style.display[@show.sheetIndex]
    
    # Note widths and heights are hard-coded to 100 units.
    @trackPadding = 20  # Padding for each vertical "track" for notes.
    @sheetHeight = 20  # Number of notes that fit on a track, vertically.  

    @computeLayout()
    @createNoteSymbols()
    @renderGuides()    

  # Computes the note sheet layout and creates the root SVG element.      
  computeLayout: ->
    # The sheet gets one vertical track for each arrow. 
    width = @displayNotes.length * (100 + 2 * @trackPadding)
    @noteX = for displayNote, i in @displayNotes
      @trackPadding + i * (100 + 2 * @trackPadding)
    
    height = 100 * @sheetHeight
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
           id("player-#{@show.stageIndex}-guide-#{i}")
