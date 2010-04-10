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

end
