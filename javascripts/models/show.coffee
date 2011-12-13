# A performance rendered by a player on a song.
class Show
  # Creates a performance.
  #
  # @param [Player] player the identity of the performer
  # @param [Number] sheetIndex the group of notes followed by the player in the
  #                            song's sheet; for example, all players follow
  #                            group 0 in dance-single sheets
  # @param [Number] showIndex the player's position on the game stage; each
  #                           player
  # @param [Song] song the song being played
  constructor: (@player, @sheetIndex, @stageIndex, @song) ->
    @metadata = {
      difficulty: {
        steps: @song.metadata.sheet.difficulty.steps,
        radar: @song.metadata.sheet.difficulty.radar
      },
      style: @song.metadata.sheet.style
    }

    # TODO(pwnall): set up sheet-tracking state
