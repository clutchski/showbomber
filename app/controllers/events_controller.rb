class EventsController < ApplicationController

  respond_to :html

  def index
    @events = Event.get_upcoming_events()
    respond_with(@events)
  end

end
