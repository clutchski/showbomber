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

  def edit
    @artist = Artist.find(params[:id])
    respond_with(@artist)
  end

  def update
    @artist = Artist.find(params[:id])
    new_song = params[:new_song]
    @artist.songs.create({:url => new_song}) if new_song
    if @artist.update_attributes(params[:artist]) or new_song
        redirect_to(@artist, :notice => 'Artist was successfully updated.')
    else
        render :action => "edit"
    end
  end

end
