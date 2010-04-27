radio.Playlist = Class.create({

  initialize : function(playlistId, playSongCallback) {
    this.DOM = radio.Playlist.DOM;

    this.container = $j('#' + playlistId);
    this.playSongCallback = playSongCallback;

    // dom references
    this.artists = this.container.find('.' + this.DOM.artistClass);
    this.songLinks = this.container.find(this.DOM.songLinkSelector);
    this.songLinks.click(this.songClickHandler.bind(this));
  },

  songClickHandler : function(event) {
    event.preventDefault();
    var songLink = $j(event.target);
    var songUrl = songLink.attr('href');
    this.playSongCallback(songUrl);
    this.highlightArtist(songLink);
  },

  highlightArtist : function(songLink) {
    this.artists.removeClass(this.DOM.nowPlayingClass);
    var artist = songLink.parent().find('.' + this.DOM.artistClass);
    artist.addClass(this.DOM.nowPlayingClass);
  }

});

// Add class methods and varibles.
Object.extend(radio.Playlist, {

  DOM : { songLinkSelector : 'a.song'
        , artistClass      : 'artist'
        , nowPlayingClass  : 'playing'
        }

});
