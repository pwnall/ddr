# Container for the views that make up a player's sub-screen.
class PlayerShowView
  constructor: (@show, @viewDom) ->
    @player = @show.player
    