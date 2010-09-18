
radio.Controller = Class.create({

  initialize : function(videoDivId, playlistDivId) {

    var Player = radio.YouTube.Player;
    this.player = new Player(videoDivId);
    $j('#' + videoDivId).live(Player.videoEnded, this.onSongEnded.bind(this));

    var Playlist = radio.Playlist;
    this.playlist = new Playlist(playlistDivId);
    var playlistDiv = $j('#' + playlistDivId);
    playlistDiv.bind(Playlist.songSelected, this.playSong.bind(this));
    playlistDiv.bind(Playlist.artistSelected, this.playArtist.bind(this));
  },

  log: function(message) {
    console.log("radio.Controller: " + message);
  },

  onSongEnded : function() {
    console.log('song ended');
    this.playlist.next();
  },

  playSong : function(event, url) {
    this.log("playing song with url : " + url);
    //FIXME: assert this is a YouTube video
    this.player.play(url);
  },

  playSongById : function(id) {
    this.player.playById(id);
  },

  playArtist : function(event, name) {
    this.log("playing artist: " + name);
    radio.YouTube.DataAPI.getVideoIdForArtist(name, 
                          this.playSongById.bind(this));
  }

});
