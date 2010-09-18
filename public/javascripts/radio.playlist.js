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

  log : function(msg) {
    console.log("radio.Playlist: " + msg);
  },

  songClickHandler : function(event) {
    event.preventDefault();
    var songLink = $j(event.target);

    this.currentSongLink = songLink;
    var songUrl = songLink.attr('href');
    this.highlightArtist(songLink);
    this.container.trigger(this.cls.songSelected, songUrl);
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

  highlightArtist : function(songLink) {
    this.artists.removeClass(this.domKeys.nowPlayingClass);
    var artist = songLink.parent().find('.' + this.domKeys.artistClass);
    artist.addClass(this.domKeys.nowPlayingClass);
  }

});

// Add class methods and varibles.
Object.extend(radio.Playlist, {

  songSelected : "songSelected",

  domKeys : { songLinkClass    : 'song'
            , artistClass      : 'artist'
            , nowPlayingClass  : 'playing'
            }

});
