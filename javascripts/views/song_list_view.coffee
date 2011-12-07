# Puts together the list of songs.
class SongListView
  constructor: ->
    @songs = SongList.songs()
    @dom = $('#song-list')
    @render @dom

  # Generates the list of songs from JSON data.
  render: ($domRoot)->
    console.log @songs
    for song in @songs
      $songLi = $("<li><span class='title' />, <span class='subtitle' /><ol></ol></li>")
      $('.title', $songLi).text song.metadata.title
      $('.subtitle', $songLi).text song.metadata.subtitle
      $domRoot.append $songLi
      $levelsList = $('ol', $songLi)
      for sheet in song.sheets
        console.log sheet
        $li = $("<li><a class='game' /> (<span class='steps' /> steps)</li>")
        $gameLink = $('.game', $li)
        steps = sheet.difficulty.steps
        $gameLink.text sheet.difficulty['class']
        $gameLink.attr('href', "/game?id=#{song.id}&steps=#{steps}")
        $('.steps', $li).text steps.toString()
        $levelsList.append $li
