
radio.Player = Class.create({

  initialize : function(videoDivId, playlistDivId) {

    this.width = 500;
    this.height = 400;

    var youtubePlayerId = 'youtubePlayer';
    this.youtubePlayer = new radio.youtube.Player(
                    youtubePlayerId, videoDivId, this.width, this.height);

    // initialize the playlist
    var playSongCallback = this.play.bind(this);
    this.playlist = new radio.Playlist(playlistDivId, playSongCallback);
  },

  log: function(message) { 
    console.log("radio.Player: " + message);
  },

  play : function(songUrl) {
    this.log("playing song with url : " + songUrl);
    //FIXME: assert this is a youtube video
    this.youtubePlayer.play(songUrl);
  }

});
