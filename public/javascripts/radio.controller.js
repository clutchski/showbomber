
radio.Controller = Class.create({

  initialize : function(videoDivId, playlistDivId) {

    var Player = radio.YouTube.Player;
    this.player = new Player(videoDivId);
    $j('#' + videoDivId).live(Player.videoEnded, this.onSongEnded.bind(this));

    this.playlist = new radio.Playlist(playlistDivId);
    this.playlist.onArtistSelected(this.playArtist.bind(this));

    //var artist = this.playlist.getNextArtistName();
    //this.loadArtist(artist);
  },

  _log: function(message) {
    console.log("radio.Controller: " + message);
  },

  onSongEnded : function() {
    this._log('song ended');
  },

  playSongById : function(id) {
    this.player.playById(id);
  },

  loadSongById : function(id) {
    this.player.loadById(id);
  },

  playArtist : function(event, name) {
    this._log("playing artist: " + name);
    radio.YouTube.DataAPI.getVideoIdForArtist(name, 
                          this.playSongById.bind(this));
  },

  loadArtist : function(name) {
    radio.YouTube.DataAPI.getVideoIdForArtist(name, 
                            this.loadSongById.bind(this));
  }
});
