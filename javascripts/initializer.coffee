# Fires up the views when the document loads.
$ ->
  switch $('body').attr('id')
    when 'song-listing'
      window.view = new SongListView
    when 'game'
      window.view = new GameView
