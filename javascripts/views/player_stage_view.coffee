# Container for the views that make up a player's piece of the stage.
class PlayerStageView
  constructor: (@cover, @viewDom) ->
    coverDom = $E('section.player-cover-view', @viewDom)
    @coverView = new PlayerCoverView @cover, coverDom
    
    @setPlayer @cover.player
    
  # Updates the view to reflect a change in the player's identity.
  setPlayer: (@player) ->
    $E('.player-name', @viewDom).textContent = player.name 
    