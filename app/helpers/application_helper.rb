module ApplicationHelper

  PLAY_LINK_IMAGE="70-tv.png"
  PLAY_LINK_CLASS="play"

  def get_play_link(artist)
    song = artist.get_song
    url = song.nil? ? "" : song.url
    link_to("", url, {:class=>"song"})
  end
end
