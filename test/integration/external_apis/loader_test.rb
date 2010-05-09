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
    artist = ArtistGenerator.generate()
    assert_nil Artist.find_by_name(artist.name)
    Loader.load_artist(artist)

    actual_artist = Artist.find_by_name(artist.name)
    assert_not_nil actual_artist
    assert_not_nil actual_artist.id
    assert_equal artist.name, actual_artist.name
  end

  test "loading the same artist does not duplicate rows" do

    # load an artist
    artist = ArtistGenerator.generate()
    assert_nil Artist.find_by_name(artist.name)
    Loader.load_artist(artist)
    assert_not_nil Artist.find_by_name(artist.name)

    # load a duplicate artist
    duplicate_artist = artist.clone
    assert_nil duplicate_artist.id
    Loader.load_artist(duplicate_artist)

    # assert only one artist with the given name exists
    artists = Artist.find(:all, :conditions=>{:name=>artist.name})
    assert_equal 1, artists.size
  end
end


#
# This class contains tests for the edge cases of loading venues
#
class ExternalAPIVenueLoaderTest < ActiveSupport::TestCase

  test "load new venue" do
    venue = VenueGenerator.generate

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

    venue = VenueGenerator.generate

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

  test "load venue with same name in different cities" do
    params = VenueGenerator.get_random_attributes()

    chicago_params = params.merge({:city => 'chicago'})
    toronto_params = params.merge({:city => 'toronto'})

    chicago_venue = VenueGenerator.generate(chicago_params)
    toronto_venue = VenueGenerator.generate(toronto_params)

    assert_nil Venue.find_by_name(params[:name])
    
    Loader.load_venue(chicago_venue)
    Loader.load_venue(toronto_venue)

    venues = Venue.all(:conditions => {:name => params[:name]})

    assert_not_nil venues
    assert_equal 2, venues.size

    cities = venues.collect{|v| v.city}
    assert cities.include?('toronto')
    assert cities.include?('chicago')
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
