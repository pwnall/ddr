# Keeps track of all songs that can be played.
class SongList
  initialize: (jsonData) ->
    @songs = jsonData
  
  # Singleton instance.
  @instance = null
  
  # Loads up a JSON list of the song index.
  @onJsonp: (jsonData) ->
    @instance = new SongList jsonData
  
  # All songs that can be played.
  @songs: ->
    @instance.songs
    
window.onSongList = (jsonData) -> SongList.onJsonp jsonData
