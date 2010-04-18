module ApplicationHelper

  PLAY_LINK_IMAGE="70-tv.png"
  PLAY_LINK_CLASS="play"

  def get_play_link(artist)
    song = artist.get_song
    link_to ("", song.url, {:class=>"play_embed"}) unless song.nil?
  end


end
