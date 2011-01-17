#
# This module contains the song repository.
#


goog.provide 'showbomber.repos.SongRepo'


class showbomber.repos.SongRepo

    constructor: () ->

    getArtistVideo: (artist, callback) ->

        @log "Fetching song info for artist [#{artist.name}]"

        params =
            type: 'GET'
            url: "/artists/#{artist.id}"
            dataType: 'json'
            success: (response, status, request) ->
                song = _.first(response.artist.songs)
                if not song
                    callback(null)
                else
                    url = song.url
                    id = if url? then parseUri(url).queryKey.v else null
                    callback(id)

        $.ajax(params)

    log: (message) ->
        showbomber.log "#{@constructor.name}: #{message}"
