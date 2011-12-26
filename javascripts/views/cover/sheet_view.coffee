# Renders a sheet of notes.
class SheetView
  constructor: (@svg, @cover) ->
    @song = @cover.song
    @chords = @song.chords
    @gradeSvgs = []
    
    @setTime 0
  
  setTime: (newTime) ->
    beat = @song.beatAtTime newTime
    
    @time = newTime
