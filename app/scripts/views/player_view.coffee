#
# This module contains the player view.
#


goog.provide 'showbomber.views.PlayerView'


goog.require 'showbomber.views.View'


class showbomber.views.PlayerView extends showbomber.views.View

    constructor: (divId) ->
        super(divId)

        # HACK: YouTube's javascript API calls static functions, so we store
        # a static reference to this class.
        showbomber.views.PlayerView._player_ = this

        @player = null

        @playerId = 'showbomber_player'
        @width = 500
        @height = 400
        @minSWFVersion = '8'

    onReady: () ->
        # The first time the player is loaded is the first video shown to the
        # user, so don't autoplay.
        if not @player
            @player = document.getElementById(@divId)
            stateChangeCallback = "onYouTubePlayerStateChange"
            @player.addEventListener("onStateChange", stateChangeCallback)
        else
            @player.playVideo()

    onStateChange: (stateId) ->
        if stateId is 0
            @log "Video ended"
            @player.clearVideo()
            this.trigger('video_ended')

    loadSong: (id) ->
        @log "Loading song #{id}"
        if not @player
            @loadPlayer(id)
        else
            @player.loadVideoById(id)

    # Load the player with the given video.
    loadPlayer: (videoId) ->

        @log "Loading player with video #{videoId}"
        url = @getEmbedUrl(videoId, @playerId)

        params = { allowScriptAccess: "always" }
        attrs  = { id: @divId, allowFullScreen: "true"}

        swfobject.embedSWF(url, @divId, @width, @height,
                      @minSWFVersion, null, null, params, attrs)

    getEmbedUrl: (videoId, playerId) ->
        return "http://www.youtube.com/v/#{videoId}" +
               "?enablejsapi=1&playerapiid=#{playerId}" +
               "&rel=0&autoplay=0&egm=0&loop=0&fs=1&hd=0&showsearch=0" +
               "&showinfo=0&iv_load_policy=3&cc_load_policy=1"



onYouTubePlayerReady = () ->
    showbomber.views.PlayerView._player_.onReady()

onYouTubePlayerStateChange = (stateId) ->
    showbomber.views.PlayerView._player_.onStateChange(stateId)

