# Shows the note that the player is currently playing.
class PlayerControlsView
  constructor: (@show, @domRoot) ->
    @player = @show.player
    @svg = new Pwnvg @domRoot, 0, 0, 400, 100
