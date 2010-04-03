class EventsController < ApplicationController

  respond_to :html

  def index
    @events = Event.all
    respond_with(@events)
  end

end
