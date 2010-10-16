#
# This module contains test cases for the application level helpers.
#

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "assert times between 1 and 9 o'clock don't start with a zero" do
    strtime = time_of_day(DateTime.new(2010, 10, 10, 7))
    assert_equal "7:00AM", strtime
    strtime = time_of_day(DateTime.new(2010, 10, 10, 19, 30))
    assert_equal "7:30PM", strtime

  end

  test "assert times between 10 and 12 o'clock are rendered properly" do
    strtime = time_of_day(DateTime.new(2010, 10, 10, 10))
    assert_equal "10:00AM", strtime
    strtime = time_of_day(DateTime.new(2010, 10, 10, 22))
    assert_equal "10:00PM", strtime
  end
end


