#
# This module contains the YouTube song repository.
#


goog.provide 'showbomber.repos.YouTubeSongRepo'


goog.require 'showbomber'


class showbomber.repos.YouTubeSongRepo

    constructor: () ->
        @apiUrl = 'http://gdata.youtube.com/feeds/api/videos'

    getArtistVideo: (artistName, callback) ->

        query = "#{artistName} live music"
        @log "Searching for song with [#{query}]"

        params =
            type: 'GET'
            url: "#{@apiUrl}?format=5&max-results=5&v=2&alt=jsonc&q=#{query}"
            dataType: 'jsonp'
            success: (response, status, request) ->
                items = response.data.items
                videoId = if items then items[0].id else null
                callback(videoId)

        $.ajax(params)

    log: (message) ->
        showbomber.log "#{@constructor.name}: #{message}"
