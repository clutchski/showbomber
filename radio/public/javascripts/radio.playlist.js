
radio.Playlist = Class.create({

  initialize : function(container_selector, player) {
    this.DOM = radio.Playlist.DOM;

    this.player = player;
    this.container = $j(container_selector);

    this.songLinks = this.container.find(this.DOM.songLinksClass);

    this.songLinks.click(this.songClickHandler.bind(this));
  }, 

  songClickHandler : function(event) {
    event.preventDefault();
    var songLink = $j(event.target);
    var songUrl = songLink.attr('href');
    console.log('clicked ' + songUrl);
    this.player.play(songUrl);
  }

});

// Add class methods and varibles.
Object.extend(radio.Playlist, {

  DOM : { songLinksClass : '.play_embed'}

});
