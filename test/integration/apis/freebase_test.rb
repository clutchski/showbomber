#
# This module contains unit tests for the freebase api
#

require 'test_helper.rb'
require 'lib/apis/freebase.rb'

class FreebaseAPITest < ActiveSupport::TestCase

  test "Can fetch artist information." do
    artist_info = Freebase.artist('Bob Dylan')

    genres = artist_info[:genres]
    assert !genres.nil?
    expected_genres = ['Folk music', 'Rock music', 'Country']
    expected_genres.each do |g|
      assert genres.include?(g)
    end

    description = artist_info[:description]
    assert !description.nil?
  end

end
