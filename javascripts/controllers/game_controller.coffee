# Helps the player select a song to play.
class GameController
  constructor: (@view) ->
    @shows = []
    
    @song = Song.singleton
    @view.setSong @song
    
    # TODO(pwnall): pull the player identities from somewhere
    @addPlayer new Player('pwnall')
    @addPlayer new Player('killdragon')

  # Adds a player to the game.
  #
  # Returns the Show instance created to represent the player's performance.
  addPlayer: (player) ->
    # Assign positions on the stage and sheet using round-robin.
    sheetIndex = @shows.length % @song.style.display.length
    stageIndex = @shows.length
    show = new Show player, sheetIndex, stageIndex, @song
    @shows.push show
    @view.addedPlayer show
    show
