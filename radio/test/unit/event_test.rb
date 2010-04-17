require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "test create without venue" do
    now = DateTime::now
    event = Event.new(:start_date=>now)
    assert !event.save, "shouldn't save event without venue"
    assert event.errors.has_key? :venue_id
  end

  test "test create without start_date" do
    now = DateTime::now
    event = Event.new(:venue_id=>101)
    assert !event.save, "shouldn't save event without start_date"
    assert event.errors.has_key? :start_date
  end

  test "test create min cost is lower than max" do
    now = DateTime::now
    event = Event.new(
      :venue_id=>101, :start_date=>now, :min_cost=>10, :max_cost=>8)
    assert !event.save, "no save when max cost is less than min cost"
    assert event.errors.has_key? :max_cost
  end

  test "test price range in words" do

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
