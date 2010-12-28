#
# This module contains the playlist controller.
#


goog.provide 'showbomber.controllers.PlaylistController'


goog.require 'showbomber'
goog.require 'showbomber.services.EventService'
goog.require 'showbomber.services.SongService'
goog.require 'showbomber.views.FilterView'
goog.require 'showbomber.views.PlayerView'
goog.require 'showbomber.views.PlaylistView'


class showbomber.controllers.PlaylistController

    constructor: () ->
        @log 'Creating playlist controller'

        @songService = new showbomber.services.SongService()
        @eventService = new showbomber.services.EventService()

        @playerView = new showbomber.views.PlayerView('video')

        @playlistView = new showbomber.views.PlaylistView('playlist')
        @playlistView.bind 'artist_selected', $.proxy(@loadArtist, this)

        @filterView = new showbomber.views.FilterView('tags')
        @filterView.bind 'filtered_by_genre', $.proxy(@loadPlaylist, this)

        artist = @playlistView.getNextArtist()
        @loadArtist(artist)

    getSongForArtist: (name) ->
        @songService.getArtistVideo(name)

    loadArtist: (artistName) ->
        @log "Playing artist #{artistName}"
        @songService.getArtistVideo(artistName, (songId) =>
            @playlistView.highlightArtist(artistName)
            @loadSong(songId)
        )

    loadSong: (songId) ->
        @log "Playing song #{songId}"
        @playerView.loadSong(songId)

    loadPlaylist: (genres) ->
        @eventService.getEventsHTML(genres, (html) =>
            @log("loading playlist")
            @playlistView.load(html)
            @filterView.reload()
        )
    
    log: (message) ->
        showbomber.log "#{@constructor.name}: #{message}"

