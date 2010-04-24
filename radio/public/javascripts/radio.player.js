radio.Player = Class.create({

  initialize : function(containerId, playlistId) {

    // statics
    this.width = 365;
    this.height = 400;
    this.minSWFVersion = '8';
    this.flashVars = null;
    this.expressSwfInstallUrl = null;

    this.containerId = containerId;
    this.playerId = 'player';

    // initialize the playlist
    var playSongCallback = this.play.bind(this);
    this.playlist = new radio.Playlist(playlistId, playSongCallback);
  },

  play : function(songUrl) {
    console.log("player: " + songUrl);
    var id = this._getId(songUrl);
    if (id) {
      this.playVideo(id);
    } else {
      //FIXME: handle errors properly
      console.error("couldn't get id for video " + songUrl);
    }
  }, 

  playVideo : function(id) {
    console.log("playing " + id);

    var embedUrl = radio.Player.EMBED_URL.evaluate({'id':id});

    var params = { allowScriptAccess: "always" };
    var attrs  = { id: this.playerId };

    swfobject.embedSWF(embedUrl, this.containerId, this.width, this.height
                      , this.minSWFVersion, null, null, params, attrs);
  },

  _getId : function(songUrl) {
    return parseUri(songUrl).queryKey[radio.Player.ID_PARAM];
  }

});

Object.extend(radio.Player, 
  { ID_PARAM : 'v'
  , EMBED_URL : new Template( 
     "http://www.youtube.com/v/#{id}?enablejsapi=1&playerapiid=ytplayer")
  , 
  }
);
