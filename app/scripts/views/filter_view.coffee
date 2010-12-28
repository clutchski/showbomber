#
# This module controls the genre filter view.
#


goog.provide 'showbomber.views.FilterView'


goog.require 'showbomber.views.View'


class showbomber.views.FilterView extends showbomber.views.View

    constructor: (divId) ->
        super(divId)
        @selected = 'selected'
        @reload()

    reload: () ->
        @$div = $("##{@divId}")
        @$tags = @$div.find('.tag')
        @$tags.click, $.proxy(@_genreFilterClickHandler, this)

    _genreFilterClickHandler: (event) ->
        $(event.target).toggleClass(@selected)
        selectedTags = @_getSelectedTags()
        @trigger('filtered_by_genre', selectedTags)
    
    _getSelectedTags: () ->
        selected = @$tags.filter('.selected')
        return selected.map( () -> this.text).toArray()

