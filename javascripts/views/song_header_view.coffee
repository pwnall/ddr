# Renders general information about the song.
class SongHeaderView
  constructor: (@song, @domRoot) ->
    $E('.song-header-title', @domRoot).textContent = song.metadata.title
    $E('.song-header-subtitle', @domRoot).textContent = song.metadata.subtitle
    $E('.song-header-artist', @domRoot).textContent = song.metadata.artist
    $E('.song-header-credit', @domRoot).textContent = song.metadata.credit

    $E('.song-difficulty-class', @domRoot).textContent =
        song.metadata.sheet.difficulty['class']
    $E('.song-difficulty-steps', @domRoot).textContent =
        song.metadata.sheet.difficulty.steps
