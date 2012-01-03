# Coordinates a show consisting of multiple players covering the same song.
class ShowController
  constructor: (@view) ->
    @beat = null
    @started = false
    @paused = false

  # Called when all the song data has been loaded.
  setSong: (@song) ->
    @show = new Show @song
    @view.setSong @song

  # Parses the JSON player data.
  setPlayers: (jsonPlayers) ->
    for jsonPlayer in jsonPlayers
      @addPlayer new Player(jsonPlayer.name)

  # Called when the game initialization completes. Invites players to start.
  ready: ->
    Controls.addListener 'global', (event) =>
      return if event.buttonDown
      if event.binding.action == 'start' and !@started
        @start()
      if event.binding.action == 'pause' and @started
        if @paused
          @paused = false
          @view.startSong()
        else
          @paused = true
          @view.pauseSong()
          
  
  # Starts the show, by starting the song.
  start: ->
    @started = true
    @show.setSongBeat 0
    @view.setSongBeat 0
    Controls.addListener 'tick', => @onTick()
    @view.startSong()

  # Adds a player to the show.
  addPlayer: (player) ->
    cover = @show.addPlayer(player)
    playerView = @view.addedPlayer cover
    Controls.addListener cover.stageIndex, (event) ->
      note = event.binding.data.note
      noteStarted = event.buttonDown
      cover.playedNote note, noteStarted if @started
      playerView.addPlayedNote note, noteStarted
    cover
  
  # Called right before the browser refreshes the views.
  onTick: ->
    time = @view.audioView.audioTime()
    beat = @song.beatAtTime time
    return if @beat == beat
    @beat = beat
    @show.setSongBeat beat
    @view.setSongBeat beat

BootLdr.initializer 'show_controller_song', ['page_controller', 'song'], ->
  window.controller.setSong Song.singleton

window.onPlayerData = (jsonPlayers) ->
  BootLdr.initializer 'show_controller_players', ['show_controller_song'], ->
    window.controller.setPlayers jsonPlayers

BootLdr.initializer 'show_ready', ['show_controller_players', 'controls',
    'song_audio_load'], -> window.controller.ready() 
  