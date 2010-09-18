
radio.Player = Class.create({

  initialize : function(videoDivId, playlistDivId) {

    this.width = 500;
    this.height = 400;

    var onSongEndedCallback = this.onSongEnded.bind(this);
    this.youtubePlayer = new radio.youtube.Controller(
        videoDivId, this.width, this.height, onSongEndedCallback);

    this.playlist = new radio.Playlist(playlistDivId);
    $j('#'+playlistDivId).bind(radio.Playlist.songSelected, this.play.bind(this));
  },

  onSongEnded : function() {
    this.playlist.next();
  },

  log: function(message) { 
    console.log("radio.Player: " + message);
  },

  play : function(event, songUrl) {
    this.log("playing song with url : " + songUrl);
    //FIXME: assert this is a youtube video
    this.youtubePlayer.play(songUrl);
  }

});
