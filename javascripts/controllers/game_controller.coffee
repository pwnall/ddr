# Helps the player select a song to play.
class GameController
  constructor: (@view) ->
    @shows = []
    
    @song = Song.singleton
    @view.setSong @song
    
    @addPlayer new Player('pwnall')

  # Adds a player to the game.
  #
  # Returns the Show instance created to represent the player's performance.
  addPlayer: (player) ->
    show = new Show player, @shows.length, @song
    @shows.push show
    @view.addedPlayer show
    show
