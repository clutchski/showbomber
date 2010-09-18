
radio.Controller = Class.create({

  initialize : function(videoDivId, playlistDivId) {

    var Player = radio.YouTube.Player;
    this.player = new Player(videoDivId);
    $j('#' + videoDivId).live(Player.videoEnded, this.onSongEnded.bind(this));

    var Playlist = radio.Playlist;
    this.playlist = new Playlist(playlistDivId);
    $j('#' + playlistDivId).bind(Playlist.songSelected, this.play.bind(this));
  },

  log: function(message) {
    console.log("radio.Controller: " + message);
  },

  onSongEnded : function() {
    console.log('song ended');
    this.playlist.next();
  },

  play : function(event, songUrl) {
    this.log("playing song with url : " + songUrl);
    //FIXME: assert this is a YouTube video
    this.player.play(songUrl);
  }

});
