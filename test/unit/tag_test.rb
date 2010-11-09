#
# This module contains tests for the Tag model.
#

require 'test_helper'

class TagTest < ActiveSupport::TestCase

  test "Tags names are stored in lowercase." do
    %w{FOLK Folk folk}.each do |name|
      tag = Factory.build(:tag, {:name => name})
      assert_equal tag.name, 'folk'
    end
  end

  test "Assert we can clean up raw tag data from the net" do
    assert_equal %w{rock}, Tag.normalize("rock")
    assert_equal %w{rock}, Tag.normalize("rock music")
    assert_equal %w{folk rock}, Tag.normalize("folk rock")
    assert_equal %w{lo-fi}, Tag.normalize("lo-fi music")
    assert_equal %w{electronic}, Tag.normalize("electronic music")
    assert_equal %w{psychadelic rock}, Tag.normalize("psychadelic rock")
    assert_equal %w{pop}, Tag.normalize("pop music")
    assert_equal %w{hip-hop}, Tag.normalize("rap") #synonyms
    assert_equal %w{indie rock}, Tag.normalize("indie rock")
    assert_equal %w{hip-hop}, Tag.normalize('hip hop')
    assert_equal %w{metal}, Tag.normalize('heavy metal')
    assert_equal %w{rock}, Tag.normalize('hard rock')
    assert_equal ['r&b'], Tag.normalize('rhythm and blues')
    assert_equal ['trip-hop'], Tag.normalize('trip hop')
  end

  test "Assert we ignore some ridiculous genres" do
    genres = ['d-beat', 'street', 'folktronica','aggrotech', 'turntablism']
    genres.each do |g|
      assert_equal [], Tag.normalize(g)
    end
  end

end
