#
# This module contains tests for the external api loader.
#

require 'test_helper'
require 'lib/external_apis/loader.rb'


#
# This class contains tests for the loading artists
#

class ExternalAPIArtistLoaderTest < ActiveSupport::TestCase

  test "load new artist" do

    # load an artist
    artist = Factory.build(:artist)
    assert_nil Artist.find_by_name(artist.name)
    Loader.load_artist(artist)

    actual_artist = Artist.find_by_name(artist.name)
    assert_not_nil actual_artist
    assert_not_nil actual_artist.id
    assert_equal artist.name, actual_artist.name
  end

  test "loading the same artist does not duplicate rows" do

    # load an artist
    artist = Factory.build(:artist)
    assert_nil Artist.find_by_name(artist.name)
    Loader.load_artist(artist)
    assert_not_nil Artist.find_by_name(artist.name)

    # load a duplicate artist
    duplicate_artist = artist.clone
    assert_nil duplicate_artist.id
    Loader.load_artist(duplicate_artist)

    # assert only one artist with the given name exists
    artists = Artist.where({:name=>artist.name}).all()
    assert_equal 1, artists.size
  end
end


#
# This class contains tests for the edge cases of loading venues
#
class ExternalAPIVenueLoaderTest < ActiveSupport::TestCase

  test "load new venue" do
    venue = Factory.build(:venue)

    # assert no such test data exists
    assert_nil Venue.find_by_name(venue.name)

    # load the venue
    Loader.load_venue(venue)

    # assert it exists
    actual_venue = Venue.find_by_name(venue.name)
    assert_not_nil actual_venue
    assert_not_nil actual_venue.id
    assert_equal venue.name, actual_venue.name
    assert_equal venue.city, actual_venue.city
  end

  test "loading a venue twice doesn't duplicate rows" do

    venue = Factory.build(:venue)

    # load a venue
    assert_nil Venue.find_by_name(venue.name)
    Loader.load_venue(venue)
    assert_not_nil Venue.find_by_name(venue.name)

    # load a duplicate venue
    duplicate_venue = venue.clone
    assert_nil duplicate_venue.id
    assert_equal venue.name, duplicate_venue.name
    Loader.load_venue(duplicate_venue)

    # assert only one venue with the given name exists
    venues = Venue.find(:all, :conditions=>{:name=>venue.name})
    assert_equal 1, venues.size
  end

  test "loading venue with same name in different cities works" do
    name = "My Test Venue"
    chicago_venue = Factory.build(:venue, {:name=> name,:city => 'chicago'})
    toronto_venue = Factory.build(:venue, {:name=> name,:city => 'toronto'})

    [chicago_venue, toronto_venue].each do |v|
      assert_nil Venue.find_by_name(v.name)
    end
    
    Loader.load_venue(chicago_venue)
    Loader.load_venue(toronto_venue)

    venues = Venue.where({:name => name}).all()

    assert_not_nil venues
    assert_equal 2, venues.size

    cities = venues.collect{|v| v.city}
    assert cities.include?('toronto')
    assert cities.include?('chicago')
  end

end

class ExternalAPILoaderTest < ActionController::IntegrationTest

  test "loading_event_twice_does_not_duplicate_rows" do
    event = Factory.build(:event)

    assert Event.by_artist(event.artists).all.empty?
    assert Event.by_venue(event.venue).all.empty?

    # create the event the first time
    assert_difference('Event.count', 1) do
      Loader.load_event(event)
    end
    # create the event the first time

    # clone the event
    duplicate_event = event.clone

    artists = event.artists.collect{|a| a.clone}
    duplicate_event.artists.clear

    artists.each do |a|
      duplicate_event.artists.build(a.clone.attributes)
    end
    duplicate_event.build_venue(event.venue.clone.attributes)

    # reload the event, assert another is not loaded
    assert_no_difference('Event.count') do
      Loader.load_event(duplicate_event)
    end
  end

  test "load_new_event_artists_venues" do

    artists = 4.times.collect{|i| Factory.build(:artist) }
    venues = 2.times.collect{|i| Factory.build(:venue) }

    artist_names = artists.collect{|a| a.name}
    venue_names = venues.collect{|v| v.name}

    # assert no events exist with the given artists/venues
    artists.each do |a|
      assert Artist.where({:name => a.name}).all.empty?
      assert Event.by_artist(a).empty?
    end

    venues.each do |v|
      assert Venue.where({:name => v.name}).all.empty?
      assert Event.by_artist(v).empty?
    end

    num_events = Event.count

    event1 = Factory.build(:event)
    event1.venue = venues[0]
    event1.artists << artists[0,2]

    event2 = Factory.build(:event)
    event1.venue = venues[1]
    event2.artists << artists[2, 5]

    Loader.load_events(events)

    assert_equal num_events + events.length, Event.count
    # assert that the data has been created
    artist_names.each{|n| assert_not_nil Artist.find_by_name(n)} 
    venue_names.each{|n| assert_not_nil Venue.find_by_name(n)} 
  end

end
