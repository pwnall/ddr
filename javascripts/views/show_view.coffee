# Container for the sub-views that make up a show.
class ShowView
  constructor: (@domRoot) ->
    @headerView = null
    @playerViews = []

  # Updates the view to reflect new song information.
  setSong: (@song) ->
    @headerView = new SongHeaderView @song, $D('header')

  # Updates the view to reflect the addition of a player.
  #
  # @param [Cover] playerCover the player's song cover in this show
  addedPlayer: (playerCover) ->
    viewDom = $H $D('#player-stage-view').textContent
    $E('article', @domRoot).appendChild viewDom
    viewDom = $E('article > section:last-child', @domRoot)
    @playerViews[playerCover.stageIndex] =
       new PlayerStageView playerCover, viewDom 
