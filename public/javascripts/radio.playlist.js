radio.Playlist = Class.create({

  onArtistSelectedEventName : 'artistSelected',
  artistClass : 'artist',
  nowPlayingClass : 'playing',
  nextSongLinkId : 'next_song',
  prevSongLinkId: 'previous_song',

  initialize : function(containerId) {
    this._container = $j('#' + containerId);
    this._fitPlaylistToWindow();

    $j(window).resize(this._fitPlaylistToWindow.bind(this));

    this._init();

  },

  _init : function () {
    this._artists = this._container.find('.artist');
    this._artists.click(this._artistClickHandler.bind(this));
    var songNavSelector = '#' + this.nextSongLinkId + ',#' + this.prevSongLinkId;
    $j(songNavSelector).click(this._songNavClickHandler.bind(this));
    $j('.tag').click(this._filterClickHandler.bind(this));
    if (this._artists.length < 1) {
      var t = this._getSelectedTags().toArray().join(' or ');
      var notice = $j('<div class="notice">Alas! We don\'t know about any ' + t
          + ' shows.</div>');
      this._container.append(notice);
    }
  },

  onArtistSelected: function(callback) {
    this._container.bind(this.onArtistSelectedEventName, callback);
  },

  selectNextArtist : function() {
    var artist = this._getNextArtistLink();
    this._selectArtistLink(artist);
    return $j(artist).html();
  },

  selectPreviousArtist : function() {
    var artist = this._getPreviousArtistLink();
    this._selectArtistLink(artist);
    return $j(artist).html();
  },

  _fitPlaylistToWindow : function() {
    var windowHeight = $j(window).height();
    var playlistHeight = windowHeight - 125;
    $j('#main').height(playlistHeight);
  },

  _log : function(msg) {
    console.log("radio.Playlist: " + msg);
  },

  _filterPlaylist : function() {
    params = {};
    params.tags = this._getSelectedTags();

    var self = this;

    $j.ajax({
      type : 'GET',
      url : '/events/service',
      data : params,
      dataType : 'html',
      success : function (response) {
        $j('#playlist').empty();
        $j('#playlist').append(response);
        self._init();
      }
    });
  },

  _filterClickHandler : function(event) {
    event.preventDefault();
    $j(event.target).toggleClass('selected');
    this._filterPlaylist();
  },

  _artistClickHandler : function(event) {
    event.preventDefault(); // don't follow the link
    var artistLink = $j(event.target);

    var name = artistLink.html();
    this._log("Clicked artist: " + name);
    this._container.trigger(this.onArtistSelectedEventName, name);
    this._selectArtistLink(artistLink);
  },

  _songNavClickHandler : function(event) {
    event.preventDefault();
    var linkId = $j(event.target).attr('id');

    var artist = (linkId === this.nextSongLinkId) ?
                  this.selectNextArtist() : this.selectPreviousArtist();
    if (artist) {
      this._container.trigger(this.onArtistSelectedEventName, artist);
    }
  },

  _getCurrentArtistLink : function() {
    return this._artists.filter('.' + this.nowPlayingClass).first();
  },

  _getPreviousArtistLink : function() {
    if (!this._artists) {
      return null;
    }

    var curArtistLink = this._getCurrentArtistLink();
    var curIndex = this._artists.index(curArtistLink);
  
    if (curIndex === null || curIndex <= 0) {
      return null;
    } else {
      return this._artists.get(curIndex-1);
    }
  },

  _getNextArtistLink : function() {
    if (!this._artists) {
      return null;
    }

    var curArtistLink = this._getCurrentArtistLink();
  
    var curIndex = this._artists.index(curArtistLink);
    var maxIndex = this._artists.length - 1;
  
    if (curIndex === null || this.curIndex >= maxIndex || this.maxIndex < 0) {
      return null;
    } else if (curIndex === -1) {
      return this._artists[0];
    } else {
      return this._artists.get(curIndex+1);
    }
  },

  _selectArtistLink : function(artistLink) {
    this._artists.removeClass(this.nowPlayingClass);
    $j(artistLink).addClass(this.nowPlayingClass);
  },

  _getSelectedTags : function() {
    return $j('#tags').find('.selected').map( function(e) {
        return this.text;
    });
  }

});
