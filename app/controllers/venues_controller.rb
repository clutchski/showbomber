class VenuesController < ApplicationController

  respond_to :html

  def index
    @venues = Venue.all
  end

  def show
    @venue = Venue.find(params[:id])
  end
end
