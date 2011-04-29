#
# This module contains unit tests for the freebase api
#

require 'test_helper.rb'
require 'lib/apis/freebase.rb'

class FreebaseAPITest < ActiveSupport::TestCase

  def verify_bob_dylan(artist_info)
    genres = artist_info[:genres]
    assert !genres.nil?
    expected_genres = ['Folk music', 'Rock music', 'Country']
    expected_genres.each do |g|
      assert genres.include?(g)
    end

    description = artist_info[:description]
    assert !description.nil?

    songs = artist_info[:songs]
    assert !songs.nil?
  end

  test "Can fetch artist information by name." do
    artist_info = Freebase.artist_by_name('Bob Dylan')
    verify_bob_dylan(artist_info)
  end

  test "Can fetch artist info by id" do
    artist_info = Freebase.artist_by_id('/en/bob_dylan')
    verify_bob_dylan(artist_info)
  end

end
