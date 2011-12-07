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
    
  # Processes the data pertaining to synchronizing notes to the audio file.
  loadSyncData: (data) ->
    @rawBpms = data.bpms.sort()
    @rawPauses = data.breaks.sort()    

  # Processes the notes data in a sheet.
  loadSheet: (rawSheet) ->
    @metadata.sheet = rawSheet.metadata
    
    # Beat range: 0 - @lastBeat
    @lastBeat = 0
    for note in rawSheet.notes
      if note.end_beat < @lastBeat
        @lastBeat = note.endBeat

  # Processes @rawBpms and @rawPauses into @beatBpm, @beatTime, and @beatPause.
  computeBeatMaps: ->
    @rawBpms.append({beat: @lastBeat, bpms: 1})
    @beatBpm = []
    beat0 = null
    bpm0 = null
    for rawBpm in @rawBpms
      if rawBpm.beat != 0
        for beat in beat0...rawBpm.beat
          @beatBpms[beat] = bpm0
      beat0 = rawBpm.beat
      bpm0 = rawBpm.bpms
    delete @rawBpms
    
    pauseIndex = 0
    @beatTimes = []
    @beatPause = {}
    time = 0
    for beat in 0..@lastBeat
      while @rawPauses[pauseIndex] && @rawPauses[pauseIndex].beat < beat
        pause = @rawPauses[pauseIndex]
        @beatPauses[pause.beat] = pause.seconds
        time += pause.seconds
        pauseIndex += 1
      @beatTimes[beat] = time    
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
