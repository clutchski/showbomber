radio.Player = Class.create({

  initialize : function(videoId, playlistId) {

    this.videoContainer = $j("#" + videoId);

    // initialize the playlist
    var playSongCallback = this.play.bind(this);
    this.playlist = new radio.Playlist(playlistId, playSongCallback);
  },

  play : function(songUrl) {
    console.log("player: " + songUrl);
  }

});

Object.extend(radio.Player, {

  EMBED_URL : new Template( 
    "http://www.youtube.com/v/#{id}?enablejsapi=1&playerapiid=ytplayer")


});
