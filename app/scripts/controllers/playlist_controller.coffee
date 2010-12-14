#
# This module contains the playlist controller.
#


goog.provide 'showbomber.controllers.PlaylistController'


goog.require 'showbomber'
goog.require 'showbomber.services.SongService'
goog.require 'showbomber.views.PlayerView'
goog.require 'showbomber.views.PlaylistView'


class showbomber.controllers.PlaylistController

    constructor: () ->
        @log 'Creating playlist controller'

        @songService = new showbomber.services.SongService()

        @playerView = new showbomber.views.PlayerView('video')

        @view = new showbomber.views.PlaylistView('playlist')
        @view.bind 'artist_selected', $.proxy(@loadArtist, this)

        artist = @view.getNextArtist()
        @loadArtist(artist)

    getSongForArtist: (name) ->
        @songService.getArtistVideo(name)

    loadArtist: (artistName) ->
        @log "Playing artist #{artistName}"
        @songService.getArtistVideo(artistName, $.proxy(@loadSong, this))

    loadSong: (songId) ->
        @log "Playing song #{songId}"
        @playerView.loadSong(songId)
    
    log: (message) ->
        showbomber.log "#{@constructor.name}: #{message}"

