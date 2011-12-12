# Container for the views that make up a player's sub-screen.
class PlayerShowView
  constructor: (@show, @viewDom) ->
    controlsDom = $E('section.player-controls-area', @viewDom)
    @controlsView = new PlayerControlsView @show, controlsDom
    sheetDom = $E('section.player-sheet-area', @viewDom)
    @sheetView = new SheetView @show, controlsDom
    
    @player = @show.player
    @setPlayer @player
    
  # Updates the view to reflect a change in the player's identity.
  setPlayer: (player) ->
    $E('.player-name', @viewDom).innerText = player.name 
    