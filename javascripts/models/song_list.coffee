# Keeps track of all songs that can be played.
class SongList
  constructor: (jsonData) ->
    @songs = jsonData
  
  # Singleton instance.
  @singleton = null
  
  # Loads up a JSON list of the song index.
  @onJsonp: (jsonData) ->
    @singleton = new SongList jsonData
  
  # All songs that can be played.
  @songs: ->
    @singleton.songs

# Callback for song list JSONP.
window.onSongList = (jsonData) -> SongList.onJsonp(jsonData)
