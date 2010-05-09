require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "events without required attributes are invalid" do
    required_attributes = [:venue, :start_date]
    required_attributes.each do |attribute|
      event = EventGenerator.generate({attribute => nil})
      assert event.invalid?, "events without #{attribute} are invalid"
    end
  end

  test "events with a greator maximum cost than minimum cost are invalid" do
    event = EventGenerator.generate({:min_cost=>10, :max_cost=>8})
    assert event.invalid?, "no save when max cost is less than min cost"
    assert event.errors.has_key? :max_cost
  end

  test "events can give a readable version of their cost" do

    # test empty range
    event = Event.new
    assert_equal "", event.price_range_in_words

    # test only minimum cost
    event.min_cost = 10
    event.max_cost = nil
    assert_equal "$10", event.price_range_in_words, "no max error"

    # test only maximum cost
    event.min_cost = nil
    event.max_cost = 12
    assert_equal "$12", event.price_range_in_words, "no min error"

    # test free event
    event.min_cost = 0
    event.max_cost = 0
    assert_equal 'free', event.price_range_in_words, "0 cost should be free"

    # test identical max and min price
    event.min_cost = 10
    event.max_cost = 10
    assert_equal "$10", event.price_range_in_words

    # test normal range
    event.min_cost = 10
    event.max_cost = 20
    assert_equal "$10 - $20", event.price_range_in_words

  end

end
