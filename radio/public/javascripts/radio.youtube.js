


radio.youtube = {

  state_by_id : $H({ '-1' : 'NOT_STARTED'
                   , '0'  : 'ENDED'
                   , '1'  : 'PLAYING'
                   , '2'  : 'PAUSED'
                   , '3'  : 'BUFFERING'
                   , '5'  : 'CUED'
                   }),

  onPlayerStateChange : function(stateId) {

    var state = radio.youtube.state_by_id.get(stateId);
    radio.youtube.controller.onPlayerStateChange(state);
  },

  onPlayerReady : function(playerId) {

    radio.youtube.controller.onPlayerReady();
  }

};

// called by youtube js api when the player is loaded
var onYouTubePlayerReady = radio.youtube.onPlayerReady;

radio.youtube.Controller = Class.create({

  initialize : function(playerId, videoDivId, width, height) {

    //HACK
    radio.youtube.controller = this;
    this.player = null;

    this.videoDivId = videoDivId;
    this.playerId = playerId;
    this.width = width;
    this.height = height;

    this.minSWFVersion = '8';
    this.flashVars = null;
    this.expressSwfInstallUrl = null;
  }, 

  log : function(message) {
    console.log("radio.youtube.Controller: " + message);
  },

  onPlayerReady : function() {
    this.player = document.getElementById(this.videoDivId);
    var stateChangeCallback = "radio.youtube.onPlayerStateChange";
    this.player.addEventListener("onStateChange", stateChangeCallback);
    this.player.playVideo();
  },

  onPlayerStateChange : function(state) {

    if (state === 'ENDED') {
      console.log("video ended");
    }
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
