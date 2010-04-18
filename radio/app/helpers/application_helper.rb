module ApplicationHelper

  PLAY_LINK_IMAGE="70-tv.png"
  PLAY_LINK_CLASS="play"

  def get_play_link(artist)
    song = artist.get_song
    link = ""

    if not song.nil?
      alt = "Play a #{artist.name} song"
      id = song.url
      img = image_tag(PLAY_LINK_IMAGE, :border=>0, :class=>"play", :id=>id,
      :alt=>alt)
      link = link_to img, song.url
    end
    link
  end


end
