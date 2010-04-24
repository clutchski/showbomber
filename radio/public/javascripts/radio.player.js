radio.Player = Class.create({

  initialize : function(videoId, playlistId) {

    this.cls = radio.Player;

    this.videoId = videoId;

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

    var embedUrl = this.cls.EMBED_URL.evaluate({'id':id});
    var width = this.cls.WIDTH;
    var height = this.cls.HEIGHT;
    var swfversion = '8';

    var params = { allowScriptAccess: "always" };
    var atts = { id: this.videoId };

    swfobject.embedSWF(embedUrl, this.videoId, width, height,
        swfversion, null, null, params, atts);
  },

  _getId : function(songUrl) {
    return parseUri(songUrl).queryKey[this.cls.ID_PARAM];
  }

});

Object.extend(radio.Player, 
  { ID_PARAM : 'v'
  , EMBED_URL : new Template( 
     "http://www.youtube.com/v/#{id}?enablejsapi=1&playerapiid=ytplayer")
  , HEIGHT: 365
  , WIDTH: 425
  , 
  }
);
