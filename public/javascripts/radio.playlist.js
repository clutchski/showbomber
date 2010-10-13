radio.Playlist = Class.create({

  onArtistSelectedEventName : 'artistSelected',
  artistClass : 'artist',
  nowPlayingClass : 'playing',

  initialize : function(containerId) {
    this._container = $j('#' + containerId);
    this._artists = this._container.find('.artist');
    this._artists.click(this._artistClickHandler.bind(this));
  },

  onArtistSelected: function(callback) {
    this._container.bind(this.onArtistSelectedEventName, callback);
  },

  _log : function(msg) {
    console.log("radio.Playlist: " + msg);
  },

  _artistClickHandler : function(event) {
    event.preventDefault(); // don't follow the link
    var artistLink = $j(event.target);
    var name = artistLink.html();
    this._log("Clicked artist: " + name);
    this._container.trigger(this.onArtistSelectedEventName, name);
    this._highlightArtist
  },

  _highlightArtist : function(artist) {
    this._artists.removeClass(this.nowPlayingClass);
    $j(artist).addClass(this.nowPlayingClass);
  },


});
