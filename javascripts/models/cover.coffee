# A player's cover (performance) of a song.
class Cover
  # Creates a cover.
  #
  # @param [Player] player the identity of the performer
  # @param [Number] sheetIndex the group of notes followed by the player in the
  #                            song's sheet; for example, all players follow
  #                            group 0 in dance-single sheets
  # @param [Number] stageIndex the player's unique position on the show's stage
  # @param [Song] song the song being covered
  constructor: (@player, @sheetIndex, @stageIndex, @song) ->
    @metadata = {
      difficulty: {
        steps: @song.metadata.sheet.difficulty.steps,
        radar: @song.metadata.sheet.difficulty.radar
      },
      style: @song.metadata.sheet.style
    }

    # TODO(pwnall): set up sheet-tracking state
