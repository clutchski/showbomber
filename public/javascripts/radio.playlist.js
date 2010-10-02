radio.Playlist = Class.create({

  initialize : function(containerId) {

    this.cls = radio.Playlist;

    this.container = $j('#' + containerId);
    this.currentSongLink = null;

    // dom references
    this.domKeys = this.cls.domKeys;
    this.artists = this.container.find('.' + this.domKeys.artistClass);
    this.songLinks = this.container.find('.' + this.domKeys.songLinkClass);
    this.songLinks.click(this.songClickHandler.bind(this));
  },

  songSelected: function(callback) {
    this.container.bind(this.cls.songSelected, callback);
  },

  artistSelected: function(callback) {
    this.container.bind(this.cls.artistSelected, callback);
  },

  selectFirstArtist : function() {
    //FIXME: This won't play a song link, if the artist has one loaded.
    var artist = this.artists.first();
    if (artist) {
      var artist_name = artist.html();
      this.highlightArtist(artist);
      return artist_name;
    }
    return null;
  },

  log : function(msg) {
    console.log("radio.Playlist: " + msg);
  },

  songClickHandler : function(event) {
    event.preventDefault(); // don't follow the link
    var songLink = $j(event.target);
    var artist = this._getArtistElement(songLink);

    this.currentSongLink = songLink;
    var songUrl = songLink.attr('href');
    if (songUrl) {
      this.container.trigger(this.cls.songSelected, songUrl);
    } else {
      this.container.trigger(this.cls.artistSelected, artist.html());
    }
    this.highlightArtist(artist);
  },

  getNextSongLink : function() {
    if (!this.songLinks) {
      return null;
    }

    var curIndex = this.songLinks.index(this.currentSongLink);
    var maxIndex = this.songLinks.length - 1;

    if (curIndex === null || this.curIndex >= maxIndex || this.maxIndex < 0) {
      return null;
    } else if (curIndex === -1) {
      return this.songLinks[0];
    } else {
      return this.songLinks.get(curIndex+1);
    }
  },

  play : function() {
    if (this.currentSongLink) {
      this.currentSongLink.click();
    } else {
      this.log("no current song selected");
    }
  },

  next : function() {
    var link = this.getNextSongLink();
    this.currentSongLink = (link) ? $j(link) : null;
    this.play();
  },

  previous : function() {
    this.currentSongLink.click();
  },

  highlightArtist : function(artist) {
    this.artists.removeClass(this.domKeys.nowPlayingClass);
    $j(artist).addClass(this.domKeys.nowPlayingClass);
  },

  _getArtistElement : function(songLink) {
    return songLink.parent().find('.' + this.domKeys.artistClass);
  }
});

// Add class methods and varibles.
Object.extend(radio.Playlist, {

  songSelected : "songSelected",
  artistSelected : "artistSelected",

  domKeys : { songLinkClass    : 'song'
            , artistClass      : 'artist'
            , nowPlayingClass  : 'playing'
            }

});
