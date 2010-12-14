#
# This module contains the playlist view.
#


goog.provide 'showbomber.views.PlaylistView'


goog.require 'showbomber.views.View'


class showbomber.views.PlaylistView extends showbomber.views.View

    constructor: (divId) ->
        super divId

        @$artists = @$div.find '.artist'
        @$artists.click $.proxy(@_artistClickHandler, this)

    getNextArtist: () ->
        @$artists.first().html()

    _artistClickHandler: (event) ->
        event.preventDefault()
        link = $(event.target)
        artistName = link.html()
        @log("Clicked artist [#{artistName}]")
        @trigger('artist_selected', artistName)
