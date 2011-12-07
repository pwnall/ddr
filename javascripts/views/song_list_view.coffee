# Puts together the list of songs.
class SongListView
  initialize: ->
    @songs = SongList.songs
    @render $('#song-list')

  render: ($domRoot)->
    console.log @songs
    for song in @songs
      $songLi = $("<li><span class='title' /><ol></ol></li>")
      $songLi.html @song.metadata.title
      $domRoot.append $songLi 
    