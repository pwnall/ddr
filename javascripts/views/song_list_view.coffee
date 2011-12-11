# Puts together the list of songs.
class SongListView
  constructor: (@domRoot)->
    @songs = SongList.songs()
    @dom = $E '#song-list', @domRoot
    @render @dom

  # Generates the list of songs from JSON data.
  render: (domRoot)->
    for song in @songs
      songLi = $H "<li><span class='title'></span>, <span class='subtitle'></span><ol></ol></li>"
      $E('.title', songLi).innerText = song.metadata.title
      $E('.subtitle', songLi).innerText = song.metadata.subtitle
      levelsList = $E 'ol', songLi

      for sheet in song.sheets
        li = $H "<li><a class='game'></a> (<span class='steps'></span> steps)</li>"
        gameLink = $E '.game', li
        steps = sheet.difficulty.steps
        gameLink.innerText = sheet.difficulty['class']
        gameLink.setAttribute('href', "/game?id=#{song.id}&steps=#{steps}")
        $E('.steps', li).innerText = steps.toString()
        levelsList.appendChild li

      domRoot.appendChild songLi
