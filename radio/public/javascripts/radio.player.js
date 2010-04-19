
radio.Player = Class.create({

  initialize : function(container_selector) {

    this.DOM = radio.Player.DOM;

    this.container = $j(container_selector);
  },

  playYouTubeVideo : function(url) {
    var params = { allowScriptAccess: "always" };
    var atts = { id: 'myytplayer'};

    var id = parseUri(url).queryKey.v;
    var embedUrl = radio.Player.YOUTUBE_EMBED_URL.evaluate({'id':id});
    swfobject.embedSWF(embedUrl, 
    this.DOM.playerId, "425", "356", "8", null, null, params, atts);
  },

  play : function(songUrl) {
    //FIXME: assert the url is for youtube
    this.playYouTubeVideo(songUrl); 
  }

});

// Add class methods and varibles.
Object.extend(radio.Player, {

  DOM : { playerId : 'player'
        },
  YOUTUBE_EMBED_URL : new Template( 
    "http://www.youtube.com/v/#{id}?enablejsapi=1&playerapiid=ytplayer")


});
