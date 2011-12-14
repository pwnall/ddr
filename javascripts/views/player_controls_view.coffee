# Shows the note that the player is currently playing.
class PlayerControlsView
  constructor: (@show, @domRoot) ->
    @player = @show.player
    
    @svg = null
    @noteSvg = []
    @renderNotes()
    
  # Puts together the images of all the notes.
  renderNotes: ->
    @svg = new Pwnvg @domRoot, 0, 0, 400, 100
    for displayNote in @show.song.style.display[@show.sheetIndex]
      image = displayNote.image
      @noteSvg[displayNote.display] =
          @svg.defs.symbol('note-' + displayNote.display).
                    viewBox(0, 0, image.width, image.height).
                    width('100%').height('100%').aspectRatio('none')
      @noteSvg[displayNote.display].rawElement image.svg
      @svg.use '#note-' + displayNote.display, 100 * displayNote.display, 0,
               100, 100
