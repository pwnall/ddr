# Renders the song's audio.
class SongAudioView
  constructor: (@song, @domRoot) ->
    @loaded = false
    @playing = false
    @completed = false
    
    @renderAudio()

  # Starts playing the song.
  playSong: ->    
    @audio.play() if @loaded and !@completed and !@playing 

  # Pauses the song, if it is playing.
  pauseSong: ->
    @audio.pause() if @playing
    
  # The time offset in the song's playback.
  #
  # @return {Number} the number of seconds into the song
  audioTime: ->
    @audio.currentTime || 0
    
  # Creates the <audio> element representing the song.
  renderAudio: ->
    audioBits = for entry in @song.audio
      "<source src=\"#{entry.path}\" type=\"#{entry.mime}\" />"
    audioHtml = '<audio controls="controls" preload="auto">' + audioBits.join('') + '</audio>'
    @domRoot.appendChild $H(audioHtml) 
    @audio = $E 'audio', @domRoot

    @audio.addEventListener 'canplaythrough', => @onLoad()
    @audio.addEventListener 'ended', => @onEnded()
    @audio.addEventListener 'pause', => @onPause()
    @audio.addEventListener 'playing', => @onPlaying()

  # Handles the <audio> element's 'canplaythrough' DOM event.
  onLoad: ->
    return if @loaded
    @loaded = true
    @playing = false
    @completed = false
    BootLdr.fireEvent 'song_audio_load'

  # Handles the <audio> element's 'ended' DOM event.
  onEnded: ->
    @playing = false
    @completed = true
  
  # Handles the <audio> element's 'pause' DOM event.
  onPause: ->
    @playing = false
    
  # Handles the <audio> element's 'playing' DOM event.
  onPlaying: ->
    @playing = true
    
BootLdr.event 'song_audio_load'
