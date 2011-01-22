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

        # jQuery objects for common elements.
        @$header = $('#header')
        @$main = $('#main')
        @$footer = $('#footer')
        @$window = $(window)

    _resizeContentToPage: () ->
        height = @$window.height() - @$footer.height() - @$header.height() - 25
        @log("Resizing main div to #{height}")
        @$main.height(height)

    log: (message) ->
        showbomber.log "#{@constructor.name}: #{message}"


$.extend(showbomber.views.View::, Backbone.Events)

