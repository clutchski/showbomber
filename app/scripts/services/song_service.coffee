#
# This module contains the song service.
#


goog.provide 'showbomber.services.SongService'


goog.require 'showbomber'
goog.require 'showbomber.repos.YouTubeSongRepo'
goog.require 'showbomber.repos.SongRepo'


class showbomber.services.SongService

    constructor: () ->
        @songRepo = new showbomber.repos.SongRepo()
        @youtubeRepo = new showbomber.repos.YouTubeSongRepo()

    getArtistVideo: (artist, callback) ->
        @songRepo.getArtistVideo(artist, (song) =>
            if song isnt undefined and song?
                callback(song)
            else
                @youtubeRepo.getArtistVideo(artist.name, callback)
        )

