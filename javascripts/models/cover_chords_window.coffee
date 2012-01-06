# Sliding window over the chords in a player's cover of a song.
class CoverChordsWindow
  # Creates an empty sliding window positioned at the beginning of the song. 
  #
  # @param {Cover} cover the cover of the player whose chords will be tracked
  constructor: (@cover) ->
    @songChords = @cover.song.chords
    @chordsArray = null
    @sheetIndex = @cover.sheetIndex
    
    @nextIn = 0
    @nextOut = 0
    @outQueue = []
  
  # Expands the sliding window to include chords starting up to lastBeat.
  #
  # Returns an array containing the indices of the added chords.
  addChords: (lastBeat) ->
    @chordsArray = null
    newChords = []
    while @nextIn < @songChords.length and
          @songChords[@nextIn].startBeat <= lastBeat
      if @songChords[@nextIn].player == @sheetIndex
        newChords.push @nextIn
        @_addChord @nextIn
      @nextIn += 1
    newChords
    
  # Shrinks the sliding window to exclude chords ending before firstBeat.
  #
  # Returns an array containing the indices of the removed chords.
  removeChords: (firstBeat) ->
    @chordsArray = null
    deadChords = []
    while @nextOut < @outQueue.length and
          @songChords[@outQueue[@nextOut]].endBeat < firstBeat
      deadChords.push @outQueue[@nextOut]
      @nextOut += 1
    deadChords
  
  # Array of chords in the sliding window.
  chords: ->
    @chordsArray ||= @outQueue[@nextOut..]

  # Adds a chord to the sliding window, without eligibility checks.
  _addChord: (chordIndex) ->
    endBeat = @songChords[chordIndex].endBeat
    i = @outQueue.length
    while i > 0 and @songChords[@outQueue[i - 1]].endBeat > endBeat
      @outQueue[i] = @outQueue[i - 1]
      i -= 1
    @outQueue[i] = chordIndex    
