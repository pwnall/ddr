# Container for the sub-views that make up a show.
class ShowView
  constructor: (@domRoot) ->
    @headerView = null
    @audioView = null
    @playerViews = []
    @beat = null

  # Updates the view to reflect new song information.
  setSong: (@song) ->
    @headerView = new SongHeaderView @song, $D('header')
    @audioView = new SongAudioView @song, $D('#song-audio-view')
    
  # Starts playing the song.
  startSong: (@song) ->
    @audioView.playSong()
    
  # Pauses the song.
  pauseSong: (@song) ->
    @audioView.pauseSong()
    
  # Updates the view to reflect the addition of a player.
  #
  # @param [Cover] playerCover the player's song cover in this show
  addedPlayer: (playerCover) ->
    viewDom = $H $D('#player-stage-view').textContent
    $E('article', @domRoot).appendChild viewDom
    viewDom = $E('article > section:last-child', @domRoot)
    @playerViews[playerCover.stageIndex] =
       new PlayerStageView playerCover, viewDom 

  # Updates the view to reflect the change in the show's time.
  #
  # @param {Number} beat the (fractional) beat offset into the song's sheet
  setSongBeat: (@beat) ->
    for view in @playerViews
      view.coverView.setSongBeat @beat
