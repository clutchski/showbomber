#
# This module contains the song service.
#


goog.provide 'showbomber.services.SongService'


goog.require 'showbomber'
goog.require 'showbomber.repos.YouTubeSongRepo'


class showbomber.services.SongService

    constructor: () ->
        @youtubeRepo = new showbomber.repos.YouTubeSongRepo()

    getArtistVideo: (artist, callback) ->
        @youtubeRepo.getArtistVideo(artist.name, callback)

