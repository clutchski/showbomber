class VenuesController < ApplicationController

  respond_to :html

  def index
    @venues = Venue.all
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def new
    @venue = Venue.new
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def create
    @venue = Venue.new(params[:venue])
    if @venue.save
      redirect_to(@venue, :notice => 'Venue was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(params[:venue])
      redirect_to(@venue, :notice => 'Venue was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy
    redirect_to(venues_url)
  end
end
