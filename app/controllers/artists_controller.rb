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

  def new
    @artist = Artist.new
    respond_with(@artist)
  end

  def edit
    @artist = Artist.find(params[:id])
    respond_with(@artist)
  end

  def create
    @artist = Artist.new(params[:artist])
    if @artist.save
      redirect_to(@artist, :notice => 'Artist was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @artist = Artist.find(params[:id])
    if @artist.update_attributes(params[:artist])
      redirect_to(@artist, :notice => 'Artist was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    redirect_to(artists_url, :notice => 'Artist was deleted')
  end

  def songs
    @artist = Artist.find(params[:id])
    respond_with(@artist)
  end

end