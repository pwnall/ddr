# Coordinates a show consisting of multiple players covering the same song.
class ShowController
  constructor: (@view) ->
    @song = Song.singleton
    @show = new Show @song

    @view.setSong @song
    
    # TODO(pwnall): pull the player identities from somewhere
    @addPlayer new Player('pwnall')
    @addPlayer new Player('killdragon')

  # Adds a player to the show.
  addPlayer: (player) ->
    cover = @show.addPlayer(player)
    @view.addedPlayer cover
    cover
