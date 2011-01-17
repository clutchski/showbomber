require 'test_helper'

class ArtistTest < ActiveSupport::TestCase

  test "Artist with tags factory works" do
    tags = 3.times.collect{|i| Factory.create(:tag)}
    artist = Factory.create(:artist, {:tags => tags})
    assert_equal tags.length, artist.tags.length
  end

  test "Add song to artist" do
    artist = Factory.create(:artist)

    assert artist.songs.empty?
    artist.songs.create({:url => 'http://foo.co'})

    song = artist.songs(true).first
    assert song
    assert song.id
    assert song.url = 'http://foo.co'
  end
end
