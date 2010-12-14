#
# This module contains an abstract base view.
#


goog.provide 'showbomber.views.View'


goog.require 'showbomber'


class showbomber.views.View

    constructor: (divId) ->
        @divId = divId
        @$div = $('#' + divId)
        @log 'Creating view'

    log: (message) ->
        showbomber.log "#{@constructor.name}: #{message}"


$.extend(showbomber.views.View::, Backbone.Events)
