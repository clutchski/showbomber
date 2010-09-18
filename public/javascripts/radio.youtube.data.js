radio.YouTube.DataAPI = {

  apiUrl: 'http://gdata.youtube.com/feeds/api/videos',
  format : 'jsonc',

  getSearchQuery : function(name) {
    return 'music ' + name;
  },

  getVideoIdForArtist : function(name, callback) {
    var url = this.apiUrl + 
         '?format=5&max-results=5&v=2&alt=jsonc&q='+this.getSearchQuery(name);
    $j.ajax({
        type: "GET",
        url: url,
        dataType: "jsonp",
        success: function(response, textStatus, XMLHttpRequest) {
            var items = response.data.items;
            var videoId = (items) ? items[0].id : null;
            callback(videoId);
        }
    });
  }
}
