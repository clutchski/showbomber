class EventsController < ApplicationController

  respond_to :html

  @@NUMBER_OF_DAYS_IN_RANGE = {'today' => 1, 'week' => 7, 'month' => 30}

  def index
    day_count = nil
    day_range_name = params['when']
    if day_range_name
      day_count = @@NUMBER_OF_DAYS_IN_RANGE[day_range_name]
      Rails.logger.debug("showing events for next n days: #{day_count}")
    end
    @events = Event.get_upcoming_events(day_count=day_count)
    respond_with(@events)
  end

  def show
    @event = Event.get_event(params[:id])
    respond_with(@event)
  end
end
