# Container for the sub-views that make up a game.
class GameView
  constructor: (@domRoot) ->
    @headerView = null
    @playerViews = []

  # Updates the view to reflect new song information.
  setSong: (@song) ->
    @headerView = new SongHeaderView @song, $D('header')

  # Updates the view to reflect the addition of a player.
  addedPlayer: (playerShow) ->
    viewDom = $H $D('#player-show-view').innerText
    $E('article', @domRoot).appendChild viewDom
    @playerViews[playerShow.playerIndex] =
       new PlayerShowView playerShow, viewDom 

# Container for the views that make up a player's sub-screen.
class PlayerShowView
  constructor: (@viewDom) ->
