#
# This module contains document.ready functions.
#


goog.provide 'showbomber.ready'


goog.require 'showbomber'
goog.require 'showbomber.controllers.PlaylistController'

showbomber.ready =

    playlist: () ->
        showbomber.log 'Playlist ready.'
        c = new showbomber.controllers.PlaylistController

