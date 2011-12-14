# Puts together the list of songs.
class SongListView
  constructor: (@domRoot)->
    @songs = SongList.songs()
    @dom = $E '#song-list', @domRoot
    @render @dom

  # Generates the list of songs from JSON data.
  render: (domRoot)->
    for song in @songs
      songLi = $H $D('#song-list-item').textContent
      $E('.title', songLi).textContent = song.metadata.title
      $E('.subtitle', songLi).textContent = song.metadata.subtitle
      levelsList = $E 'ol', songLi

      for sheet in song.sheets
        li = $H $D('#song-list-sheet-item').textContent
        gameLink = $E '.game', li
        gameLink.textContent = sheet.difficulty['class']
        steps = sheet.difficulty.steps
        style = sheet.style
        gameLink.setAttribute 'href',
            "/game?id=#{song.id}&steps=#{steps}&style=#{style}"
        $E('.steps', li).textContent = steps.toString()
        $E('.sheet-style', li).textContent = style.replace('_', '-')
        levelsList.appendChild li

      domRoot.appendChild songLi
