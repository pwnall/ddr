# Container for the views that make up a player's piece of the stage.
class PlayerStageView
  constructor: (@cover, @viewDom) ->
    coverDom = $E('section.player-cover-view', @viewDom)
    @coverView = new PlayerCoverView @cover, coverDom
    
    @setPlayer @cover.player
    
  # Updates the view to reflect a change in the player's identity.
  setPlayer: (@player) ->
    $E('.player-name', @viewDom).textContent = player.name 
    
  # Updates the view to reflect a player move.
  #
  # @param {Number} note the index of the note that is playing
  # @param {Boolean} noteStarted if true, the player started playing the note,
  #                              otherwise the player just stopped playing it
  addPlayedNote: (note, noteStarted) ->
    @coverView.addPlayedNote note, noteStarted
