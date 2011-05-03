class VenuesController < ApplicationController

  respond_to :html

  def index
    @venues = Venue.all
  end

  def show
    @venue = Venue.find(params[:id])
    @events = Event.get_upcoming_events(nil, [], @venue.id)
  end
end
