#
# This module contains the playlist controller.
#


goog.provide 'showbomber.controllers.PlaylistController'


goog.require 'showbomber'
goog.require 'showbomber.services.SongService'
goog.require 'showbomber.views.PlaylistView'


class showbomber.controllers.PlaylistController

    constructor: () ->
        @log 'Creating playlist controller'

        @songService = new showbomber.services.SongService()

        @view = new showbomber.views.PlaylistView('playlist')
        @view.bind 'artist_selected', $.proxy(@playArtist, this)

    playArtist: (artistName) ->
        @log "Playing artist #{artistName}"
        @songService.getArtistVideo(artistName, $.proxy(@playSong, this))

    playSong: (songId) ->
        @log "Playing song #{songId}"
    
    log: (message) ->
        showbomber.log "#{@constructor.name}: #{message}"

