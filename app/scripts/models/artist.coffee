#
# This module contains the Artist class.
#


goog.provide 'showbomber.models.Artist'


goog.require 'showbomber'


class showbomber.models.Artist

    constructor: (id, name) ->
        @id = id
        @name = name
