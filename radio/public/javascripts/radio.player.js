
radio.Player = Class.create({

  initialize : function(container_selector, playlist) {
    this.container = $j(container_selector);
    this.playlist = playlist;
  }

});
