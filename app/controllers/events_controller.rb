class EventsController < ApplicationController

  respond_to :html

  def index
    @events = Event.all(:order => "start_date ASC")
    respond_with(@events)
  end

end
