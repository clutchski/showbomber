radio.YouTube = {
  
  controller : null,

  state_by_id : $H({ '-1' : 'NOT_STARTED'
                   , '0'  : 'ENDED'
                   , '1'  : 'PLAYING'
                   , '2'  : 'PAUSED'
                   , '3'  : 'BUFFERING'
                   , '5'  : 'CUED'
                   }),

  onPlayerStateChange : function(stateId) {
    var state = radio.YouTube.state_by_id.get(stateId);
    radio.YouTube.controller.onPlayerStateChange(state);
  }
};

radio.YouTube.Player = Class.create({

  initialize : function(videoDivId, width, height, songEndedCallback) {

    radio.YouTube.controller = this;
    this.player = null;

    this.videoDivId = videoDivId;
    this.playerId = 'radioYoutubePlayer';

    this.width = 500;
    this.height = 400;
    this.videoEndedCallback = songEndedCallback;

    this.minSWFVersion = '8';
  }, 

  log : function(message) {
    console.log("radio.YouTube.Controller: " + message);
  },

  onPlayerReady : function() {
    this.player = document.getElementById(this.videoDivId);
    var stateChangeCallback = "radio.YouTube.onPlayerStateChange";
    this.player.addEventListener("onStateChange", stateChangeCallback);
    this.player.playVideo();
  },

  onPlayerStateChange : function(state) {

    if (state === 'ENDED') {
      this.log("video ended");
      this.videoEndedCallback();
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

/* This function is called by the YouTube javascript API
 * when the player is ready.
 */
var onYouTubePlayerReady = function(playerId) {
  radio.YouTube.controller.onPlayerReady();
};


