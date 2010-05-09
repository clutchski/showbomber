#
# This module contains integration tests for the Event model
#

require 'test_helper'


class EventTest < ActiveSupport::TestCase

  test "events can be found with the scope by_venue" do
    venue = VenueGenerator.persisted
    assert_not_nil venue.id
    assert Event.by_venue(venue).empty?

    num_events = 3
    num_events.times.each { |i| EventGenerator.persisted({:venue => venue})}

    events = Event.by_venue(venue)
    assert !events.empty?
    assert_equal num_events, events.size
    events.each{ |e| assert_equal venue, e.venue }
  end

  #test "events can be found with the scope by_artist" do
  #  artist = ArtistGenerator.persisted
  #  assert_not_nil artist.id

  #  assert Event.by_artist(artist).all().empty?

  #  num_events = 3
  #  num_events.times.each do |i| 
  #    EventGenerator.persisted({:artists => [artist]})
  #  end

  #  puts Event.by_artist(artist).to_sql()
  #  events = Event.by_artist(artist).all()
  #  puts events
  #  assert !events.empty?
  #  assert_equal num_events, events.size
  #  events.each do assert e.artists.include(artist) }
  #end
end
