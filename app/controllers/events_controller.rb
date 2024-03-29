class EventsController < ApplicationController

  respond_to :html

  @@NUMBER_OF_DAYS_IN_RANGE = {'today' => 1, 'week' => 7, 'month' => 30}

  def index
    day_count = nil
    day_range_name = params['when']
    #FIXME: add support for multiple tags
    tag = params['tag']
    tags = tag ? [tag] : []
    if day_range_name
      day_count = @@NUMBER_OF_DAYS_IN_RANGE[day_range_name]
      Rails.logger.debug("showing events for next n days: #{day_count}")
    end
    @tags = Tag.get_approved_tags()
    @events = Event.get_upcoming_events(day_count=day_count, tags=tags)
    @active_tags = []
    respond_with(@events)
  end

  def service
    tags = params['tags'] || []

    @events = Event.get_upcoming_events(day_count=nil, tags=tags)

    @tags = Tag.get_approved_tags()
    @active_tags = tags
    render "events/index", :layout => false
  end

  def show
    @event = Event.get_event(params[:id])
    respond_with(@event)
  end
end
