
require 'test_helper'
require 'lib/etl/transformer/tags.rb'

class ETLTransformerTagTest < ActiveSupport::TestCase

  def transform(tag)
    return ETL::Transformer::Tags.transform(tag)
  end

  test "Assert we can clean up raw tag data from the net" do
    assert_equal %w{rock}, transform("rock")
    assert_equal %w{rock}, self.transform("rock music")
    assert_equal %w{folk rock}, self.transform("folk rock")
    assert_equal %w{indie folk}, self.transform("indie folk")
    assert_equal %w{lo-fi}, self.transform("lo-fi music")
    assert_equal %w{electronic}, self.transform("electronic music")
    assert_equal %w{psychadelic rock}, self.transform("psychadelic rock")
    assert_equal %w{pop}, self.transform("pop music")
    assert_equal %w{hip-hop}, self.transform("rap") #synonyms
    assert_equal %w{indie rock}, self.transform("indie rock")
    assert_equal %w{hip-hop}, self.transform('hip hop')
    assert_equal %w{metal}, self.transform('heavy metal')
    assert_equal %w{rock}, self.transform('hard rock')
    assert_equal %w{hardcore}, self.transform('thrashcore')
    assert_equal %w{punk}, self.transform('street punk')
    assert_equal ['r&b'], self.transform('rhythm and blues')
  end

  test "Assert we ignore some ridiculous genres" do
    genres = ['d-beat', 'street', 'folktronica','aggrotech', 'turntablism']
    genres.each do |g|
      assert_equal [], self.transform(g)
    end
  end



end


