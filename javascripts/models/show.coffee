# Multiple players covering the same song at the same time.
class Show
  # Creates a show where all the players cover the given song.
  constructor: (@song) ->
    @covers = []
    @time = null
    
  # Registers the identity of a player who will be covering the song.
  #
  # This method assigns a stage position for the new player, as well as a group
  # of notes on the song's sheet.
  #
  # @return {Cover} a new Cover instance representing the player's performance
  addPlayer: (player) ->
    # Assign positions on the stage and sheet using round-robin.
    stageIndex = @covers.length
    sheetIndex = stageIndex % @song.style.display.length
    cover = new Cover player, sheetIndex, stageIndex, @song
    @covers.push cover
    cover
    
  # Updates the show's time offset.
  #
  # @param {Number} beat the (fractional) beat offset into the song's sheet
  setSongBeat: (@beat) ->
    for cover in @covers
      cover.setSongBeat @beat
