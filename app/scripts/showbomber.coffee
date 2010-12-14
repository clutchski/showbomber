#
# This module is the root of the showbomber namespace.
#
# It contains global utility functions, like logging.
#


goog.provide 'showbomber'


showbomber =

    # If a browser console is loaded, log the given message.
    log : (message) ->
        if console?
            now = new Date().toLocaleTimeString()
            console.log "#{now} #{message}"
