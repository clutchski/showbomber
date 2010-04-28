
radio.youtube = {

  playerReadyCallBacks : $H(),

  registerPlayerReadyCallback : function(playerId, callback) {
    this.playerReadyCallBacks.set(playerId, callback);
  }

};

/* This function is called by the javascript api whenever a youtube 
 * player is enabled.
 */
function onYouTubePlayerReady(playerId) {
  var callback = radio.youtube.playerReadyCallBacks.get(playerId);
  if (!callback) {
    console.error("no youtube player registered with id " + playerId);
  } else {
    callback(playerId);
  }
};

/*
 * This class controls a YouTube player.
 */
radio.youtube.Player = Class.create({

  initialize : function(playerId, videoDivId, width, height) {

    this.videoDivId = videoDivId;
    this.playerId = playerId;
    this.width = width;
    this.height = height;

    this.minSWFVersion = '8';
    this.flashVars = null;
    this.expressSwfInstallUrl = null;
    
    radio.youtube.registerPlayerReadyCallback(
                    playerId, this.playerReadyCallback.bind(this));
  }, 

  log : function(message) {
    console.log("radio.youtube.Player: " + message);
  },

  playerReadyCallback : function(playerId) {
    this.log("player ready callback " + playerId);
  },

  play : function(url) {

    this.log("playing song " + url);

    var videoId = this._getVideoId(url);
    var embedUrl = this._getEmbedUrl(videoId);

    var params = { allowScriptAccess: "always" };
    var attrs  = { id: this.videoDivId };

    swfobject.embedSWF(embedUrl, this.videoDivId, this.width, this.height
                      , this.minSWFVersion, null, null, params, attrs);

  },

  _getVideoId : function(url) {
    return parseUri(url).queryKey['v'];
  },

  _getEmbedUrl : function(videoId) {

      var template = new Template(
   "http://www.youtube.com/v/#{videoId}?enablejsapi=1&playerapiid=#{playerId}"
      );
      return template.evaluate({'videoId':videoId, 'playerId':this.playerId});
  }

});
