#
# This module contains the playlist view.
#


goog.provide 'showbomber.views.PlaylistView'


goog.require 'showbomber.views.View'
goog.require 'showbomber.models.Artist'


class showbomber.views.PlaylistView extends showbomber.views.View

    constructor: (divId) ->
        super divId
        @_initializeBehaviours()

    # Load the playlist with the given html.
    load: (html) ->
        @log("Reloading the playlist")
        @$div.empty()
        @$div.append(html)
        @_initializeBehaviours()

    getNextArtist: () ->
        return @_parseArtist(@$artists.first())

    highlightArtist: (artist) ->
        cls = 'playing'
        @$artists.removeClass(cls)
        # FIXME: better to search by the id attribute?
        @$artists.filter(":contains(#{artist.name})").addClass(cls)

    _initializeBehaviours: () ->
        @$artists = @$div.find '.artist'
        @$artists.click $.proxy(@_artistClickHandler, this)

    _parseArtist: ($link) ->
        name = $link.html()
        id = $link.attr('artist_id')
        return new showbomber.models.Artist(id, name)

    _artistClickHandler: (event) ->
        event.preventDefault()

        $link = $(event.target)
        artist = @_parseArtist($link)

        @log("Clicked artist [#{artist.name}]")
        @trigger('artist_selected', artist)
