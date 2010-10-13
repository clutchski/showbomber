
radio.Controller = Class.create({

  initialize : function(videoDivId, playlistDivId) {

    var Player = radio.YouTube.Player;
    this._player = new Player(videoDivId);
    $j('#' + videoDivId).live(Player.videoEnded, this.onSongEnded.bind(this));

    this.playlist = new radio.Playlist(playlistDivId);
    this.playlist.onArtistSelected(this.onArtistSelected.bind(this));

    var artist = this.playlist.selectNextArtist();
    this._loadArtist(artist);
  },

  _log: function(message) {
    console.log("radio.Controller: " + message);
  },

  onSongEnded : function() {
    var artist = this.playlist.selectNextArtist();
    this._playArtist(artist);
  },

  onArtistSelected :function(event, name) {
    this._playArtist(name);
  },

  _playSongById : function(id) {
    this._player.playById(id);
  },

  _loadSongById : function(id) {
    this._player.loadById(id);
  },

  _playArtist : function(name) {
    this._log("Playing artist: " + name);
    radio.YouTube.DataAPI.getVideoIdForArtist(name, 
                          this._playSongById.bind(this));
  },

  _loadArtist : function(name) {
    radio.YouTube.DataAPI.getVideoIdForArtist(name, 
                            this._loadSongById.bind(this));
  }
});
