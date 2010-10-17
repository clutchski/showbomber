class ArtistsController < ApplicationController

  respond_to :html

  def index
    @artists = Artist.all(:order => :name)
    respond_with(@artists)
  end

  def show
    @artist = Artist.find(params[:id])
    respond_with(@artist)
  end
end
