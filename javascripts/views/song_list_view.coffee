# Puts together the list of songs.
class SongListView
  constructor: (@domRoot)->
    @songs = SongList.songs()
    @dom = $E '#song-list', @domRoot
    @render @dom

  # Generates the list of songs from JSON data.
  render: (domRoot)->
    for song in @songs
      songLi = $H $D('#song-list-item').innerText
      $E('.title', songLi).innerText = song.metadata.title
      $E('.subtitle', songLi).innerText = song.metadata.subtitle
      levelsList = $E 'ol', songLi

      for sheet in song.sheets
        li = $H $D('#song-list-sheet-item').innerText
        gameLink = $E '.game', li
        steps = sheet.difficulty.steps
        gameLink.innerText = sheet.difficulty['class']
        gameLink.setAttribute('href', "/game?id=#{song.id}&steps=#{steps}")
        $E('.steps', li).innerText = steps.toString()
        $E('.sheet-style', li).innerText = sheet.style.replace('_', '-')
        levelsList.appendChild li

      domRoot.appendChild songLi
