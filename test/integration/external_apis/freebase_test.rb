#
# This module contains unit tests for the freebase api
#

require 'test_helper.rb'
require 'lib/external_apis/freebase.rb'

class FreebaseAPITest < ActiveSupport::TestCase

  test "Can fetch artist genres" do
    genres = Freebase.music_genres('Bob Dylan')
    assert !genres.nil?
    expected_genres = ['Folk music', 'Rock music', 'Country']
    expected_genres.each do |g|
      assert genres.include?(g)
    end
  end

end
