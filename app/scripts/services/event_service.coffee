#
# This module contains the event service.
#


goog.provide 'showbomber.services.EventService'


goog.require 'showbomber'


class showbomber.services.EventService

    constructor: () ->
        @apiURL = '/events/service'

    log: (message) ->
        showbomber.log("EventService: #{message}")

    # Return the HTML for events with the given tags.
    getEventsHTML: (tags, callback) ->

        @log("Fetching events for #{tags.join(',')}")

        options =
            url : @apiURL
            type : 'GET'
            data : {tags: tags}
            dataType : 'html'
            success: callback

        $.ajax(options)

