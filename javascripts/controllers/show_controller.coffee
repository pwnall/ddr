# Coordinates a show consisting of multiple players covering the same song.
class ShowController
  constructor: (@view) ->

  # Called when all the song data has been loaded.
  setSong: (@song) ->
    @show = new Show @song
    @view.setSong @song

  # Parses the JSON player data.
  setPlayers: (jsonPlayers) ->
    for jsonPlayer in jsonPlayers
      @addPlayer new Player(jsonPlayer.name)

  # Starts the show, by starting the song.
  start: ->
    @view.startSong()

  # Adds a player to the show.
  addPlayer: (player) ->
    cover = @show.addPlayer(player)
    @view.addedPlayer cover
    cover

BootLdr.initializer 'show_controller_song', ['page_controller', 'song'], ->
  window.controller.setSong Song.singleton

window.onPlayerData = (jsonPlayers) ->
  BootLdr.initializer 'show_controller_players', ['show_controller_song'], ->
    window.controller.setPlayers jsonPlayers

BootLdr.initializer 'show_start', ['show_controller_players', 'controls',
    'song_audio_load'], -> window.controller.start()
