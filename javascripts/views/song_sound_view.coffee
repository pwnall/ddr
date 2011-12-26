# Renders the song's audio.
class SongSoundView
  constructor: (@song, @domRoot) ->
    @loaded = false
    @playing = false
    @completed = false
    
    @renderAudio()
    
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
    @loaded = true
    @playing = false
    @completed = false
    @audio.play()

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
    
