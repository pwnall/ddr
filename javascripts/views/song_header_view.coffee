# Renders general information about the song.
class SongHeaderView
  constructor: (@song, @domRoot) ->
    $E('.song-header-title', @domRoot).innerText = song.metadata.title
    $E('.song-header-subtitle', @domRoot).innerText = song.metadata.subtitle
    $E('.song-header-artist', @domRoot).innerText = song.metadata.artist
    $E('.song-header-credit', @domRoot).innerText = song.metadata.credit

    $E('.song-difficulty-class', @domRoot).innerText =
        song.metadata.sheet.difficulty['class']
    $E('.song-difficulty-steps', @domRoot).innerText =
        song.metadata.sheet.difficulty.steps
