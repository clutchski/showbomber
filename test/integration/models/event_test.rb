#
# This module contains integration tests for the Event model
#

require 'test_helper'


class EventTest < ActiveSupport::TestCase

  test "events can be found with the scope by_venue" do
    venue = Factory.create(:venue)
    assert_not_nil venue.id
    assert Event.by_venue(venue).empty?

    num_events = 3
    num_events.times.each { |i| Factory.create(:event, {:venue => venue})}

    events = Event.by_venue(venue)
    assert !events.empty?
    assert_equal num_events, events.size
    events.each{ |e| assert_equal venue, e.venue }
  end

  test "events can be found with the scope by_artist" do
    artist = Factory.create(:artist)
    assert_not_nil artist.id

    assert Event.by_artist(artist).all().empty?

    num_events = 3
    num_events.times.each do |i| 
      event = Factory.create(:event, {:artists => [artist]})
    end

    events = Event.by_artist(artist).all()
    assert !events.empty?
    assert_equal num_events, events.size
    events.each do |e| 
      assert e.artists.include?(artist)
    end
  end

  test "events in the past aren't included in upcoming events" do
    days_ago = [10, 5, 1]
    past_events = days_ago.collect do |d| 
      Factory.create(:event, :start_date => d.days.ago)
    end

    upcoming_events = Event.get_upcoming_events()

    past_events.each do |e|
      assert !upcoming_events.include?(e), 
        "upcoming events shouldn't include past event: #{e.start_date}"
    end
  end

  test "assert today's events are included in upcoming events" do
    show_times = [6, 12, 17, 23]
    midnight = DateTime.now.midnight
    events = show_times.collect do |t|
      start_date = midnight + (60*60 * t)
      Factory.create(:event, :start_date => start_date)
    end

    upcoming_events = Event.get_upcoming_events()

    events.each do |e|
      assert upcoming_events.include?(e)
    end
  end
end
