/**
 * This class controls the YouTube player.
 */
radio.YouTube.Player = Class.create({

  initialize : function(containerId) {

    radio.YouTube.Player.singleton = this;

    this.cls = radio.YouTube.Player;
    this.containerId = containerId;
    this.player = null;

    this.playerId = 'radioYouTubePlayer';
    this.width = 500;
    this.height = 400;
    this.minSWFVersion = '8';
  }, 

  log : function(message) {
    console.log("radio.YouTube.Player: " + message);
  },

  onPlayerReady : function() {
    this.player = document.getElementById(this.containerId);
    var stateChangeCallback = "radio.YouTube.Player.singleton.onStateChange";
    this.player.addEventListener("onStateChange", stateChangeCallback);
    if (this.playWhenLoaded) {
      this.player.playVideo();
    }
  },

  onStateChange : function(stateId) {
    if (stateId === this.cls.states.ENDED) {
      this.log("video ended");
      $j('#' + this.containerId).trigger(this.cls.videoEnded);
    }
  },

  play : function(url) {
    this.log("playing song " + url);
    var videoId = this._getVideoId(url);
    this.playById(videoId);
  },

  playById : function(videoId) {
    this.playWhenLoaded = true;
    this._load(videoId);
  },

  load : function(url) {
    var videoId = this._getVideoId(url);
    this.loadById(videoId);
  },

  loadById : function(videoId) {
    this.playWhenLoaded = false;
    this._load(videoId);
  },

  _load : function(videoId) {
    
    this.log("loading video with id: " + videoId);
    var embedUrl = this._getEmbedUrl(videoId);

    var params = { allowScriptAccess: "always" };
    var attrs  = { id: this.containerId };

    swfobject.embedSWF(embedUrl, this.containerId, this.width, this.height
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

Object.extend(radio.YouTube.Player, {

  singleton: null,

  videoEnded : 'videoEnded',

  states : { NOT_STARTED : -1
           , ENDED : 0
           , PLAYING : 1
           , PAUSED : 2
           , BUFFERING : 3
           , CUED : 5
           },

  onStateChange : function(stateId) {
    radio.YouTube.Player.singleton.onStateChange(stateId);
  }
});

/* This function is called by the YouTube javascript API
 * when the player is ready.
 */
var onYouTubePlayerReady = function() {
  radio.YouTube.Player.singleton.onPlayerReady();
};
