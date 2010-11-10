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
end
