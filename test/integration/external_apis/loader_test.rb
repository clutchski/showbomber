#
# This module contains tests for the external api loader.
#

require 'test_helper'
require 'lib/external_apis/loader.rb'


#
# This class contains tests for the edge cases of loading venues
#
class ExternalAPIVenueLoaderTest < ActiveSupport::TestCase

  test "load new venue" do
    venue = new_venue({"the caruso club" => name})

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

  test "load identical venue" do
    params = get_random_venue_params()

    venue1 = new_venue(params)

    # load a new venue once, and assert it works
    assert_nil Venue.find_by_name(venue1.name)
    Loader.load_venue(venue1)
    actual_venue1 = Venue.find_by_name(venue1.name)
    assert_not_nil actual_venue1
    assert_not_nil actual_venue1.id

    # load the same venue again, and assert the data is identical
    venue2 = new_venue(params)
    Loader.load_venue(venue2)
    actual_venue2 = Venue.find_by_name(venue2.name)
    assert_equal actual_venue1.id,   actual_venue2.id
    assert_equal actual_venue1.name, actual_venue2.name

  end

end

class ExternalAPILoaderTest < ActionController::IntegrationTest

  test "load_new_event_artists_venues" do

    artist_names = 4.times.collect{|i| "artist_#{i}"}
    venue_names = 2.times.collect{|i| "venue_#{i}"}

    artists = artist_names.collect{|n| Artist.new(:name => n)}
    venues = venue_names.collect do |name|
      Venue.new do |venue|
        venue.name = name
        venue.address = "123 Fake Street"
        venue.city = "New York"
        venue.state = "NY"
      end
    end

    # assert no test data exists
    assert Artist.find(:all, :conditions=>["name in (?)", artist_names]).empty?
    assert Venue.find(:all, :conditions=>["name in (?)", venue_names]).empty?

    assert Event.find(:all, :joins=>[:artists, :venue],
            :conditions=>["artists.name in (?) OR venues.name in (?)",
                              artist_names,venue_names]).empty?

    num_events = Event.count(:all)


    start_date = 5.days.from_now
    event1 = Event.new(:artists=> artists[0,2], :venue=>venues[0],
                                                    :start_date=>start_date)
    event2 = Event.new(:artists=> artists[2,5], :venue=>venues[1],
                                              :start_date=>start_date)
    events = [event1, event2]

    Loader.load_events(events)

    assert_equal num_events + events.length, Event.count(:all)

    # assert that the data has been created
    artist_names.each{|n| assert_not_nil Artist.find_by_name(n)} 
    venue_names.each{|n| assert_not_nil Venue.find_by_name(n)} 


  end

end