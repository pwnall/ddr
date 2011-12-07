# Sets up everything when the document loads.
$ ->
  console.log $('body').attr('id')
  switch $('body').attr('id')
    when 'song-listing'
      window.view = new SongListView
    when 'game'
      window.view = new GameView
