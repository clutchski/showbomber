radio.Playlist = Class.create({

  initialize : function(playlistId, playSongCallback) {
    this.DOM = radio.Playlist.DOM;

    this.container = $j('#' + playlistId);
    this.playSongCallback = playSongCallback;

    this.songLinks = this.container.find(this.DOM.songLinksClass);
    this.songLinks.click(this.songClickHandler.bind(this));
  }, 

  songClickHandler : function(event) {
    event.preventDefault();
    var songLink = $j(event.target);
    var songUrl = songLink.attr('href');
    console.log('passing song to player: ' + songUrl);
    this.playSongCallback(songUrl);
  }

});

// Add class methods and varibles.
Object.extend(radio.Playlist, {

  DOM : { songLinksClass : '.play_embed'}

});
