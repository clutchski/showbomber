class EventsController < ApplicationController

  respond_to :html

  def index
    @events = Event.get_upcoming_events()
    render :layout => 'playlist'
  end

  def show
    @event = Event.where('id = ?', params[:id]).includes([:venue]).first()
    respond_with(@event)
  end
end
