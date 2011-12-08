# A song to be played.
class Song
  # Parses the song's JSON description.
  #
  # The song won't be usable until seletSheet is called.
  constructor: (jsonData) ->
    @metadata = jsonData.metadata
    @musicUrl = jsonData.music    
    @rawSheets = jsonData.sheets
    @loadSyncData jsonData.sync

  # Processes the note sheet for the given difficulty level.
  seletSheet: (steps) ->
    for sheet in @rawSheets
      if sheet.metadata.difficulty.steps == steps
        @loadSheet sheet
        break
    delete @rawSheets
    
  # Returns the beat at a time.
  # 
  # @param [Number] time the time, expressed in seconds
  # @return [Number] the beat number; can be negative and/or fractional
  beatAtTime: (time) ->
    # Binary search for the base beat.
    low = 0 
    high = @lastBeat
    while low <= high
      middle = (low + high) >> 1
      if time < @beatTime[middle]
        high = middle - 1
      else if time > @beatTime[middle]
        low = middle + 1
      else
        break
    
    # High will be -1 if the time is before the song's start.
    high = 0 if high < 0

    high + (time - @beatTime[high]) * @beatBpm[high] / 60.0
    
  # Processes the data pertaining to synchronizing notes to the audio file.
  loadSyncData: (data) ->
    @rawBpms = data.bpms
    @rawPauses = data.breaks.sort()    

  # Processes the notes data in a sheet.
  loadSheet: (rawSheet) ->
    @metadata.sheet = rawSheet.metadata
    
    # Beat range: 0 - @lastBeat
    @lastBeat = @computeLastBeat rawSheet.notes
    @computeBeatMaps()

  # Computes the maximum of the given notes' ending beat. 
  computeLastBeat: (notes) ->
    lastBeat = 0
    for note in notes
      beat = note.end_beat || note.start_beat
      lastBeat = beat if lastBeat < beat
    lastBeat

  # Processes @rawBpms and @rawPauses into @beatBpm, @beatTime, and @beatPause.
  computeBeatMaps: ->
    @rawBpms.sort()
    @rawBpms.push({beat: @lastBeat + 1, bpms: 1})
    @beatBpm = []
    beat0 = null
    bpm0 = 0
    for rawBpm in @rawBpms
      for beat in [beat0...(rawBpm.beat)]
        @beatBpm[beat] = bpm0
      beat0 = rawBpm.beat
      bpm0 = rawBpm.bpm
    delete @rawBpms
    
    @beatTime = []
    @beatPause = {}
    time = 0
    pauseIndex = 0
    console.log @rawPauses
    for beat in [0..@lastBeat]
      while @rawPauses[pauseIndex] && @rawPauses[pauseIndex].beat < beat
        pause = @rawPauses[pauseIndex]
        @beatPause[pause.beat] = pause.seconds
        time += pause.seconds
        pauseIndex += 1
      @beatTime[beat] = time
      time += 60.0 / @beatBpm[beat]
    delete @rawPauses
    

  # Singleton instance.
  @singleton = null
  
# Callback for song data JSONP.
window.onSongData = (jsonData) ->
  Song.singleton = new Song jsonData

# Callback for song difficulty data JSONP.
window.onSongDifficulty = (jsonData) ->
  Song.singleton.seletSheet jsonData.steps

# Help debugging.
window.Song = Song
