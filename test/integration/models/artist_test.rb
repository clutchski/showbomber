require 'test_helper'

class ArtistTest < ActiveSupport::TestCase

  test "Artist with tags factory works" do
    tags = 3.times.collect{|i| Factory.create(:tag)}
    artist = Factory.create(:artist, {:tags => tags})
    assert_equal tags.length, artist.tags.length
  end
end
