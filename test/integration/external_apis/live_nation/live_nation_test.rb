#
# This module contains test for the live nation api.
#

# stdlib
require 'test_helper'

# project
require 'lib/external_apis/live_nation.rb'

class LiveNationTest < ActionController::IntegrationTest

  def this_dir
    File.dirname(__FILE__)
  end

  test "test extractor works" do
    xml_data = LiveNationAPI::Extractor.extract(test_mode=true)
    assert xml_data.is_a? Hash
    assert xml_data.has_key? 'result'
    events = xml_data['result']
    assert events.has_key? 'event'
    assert events['event'].is_a? Array
  end

  def parse_xml(xml)
    # Crack is the parsing library used in httparty. definitely an abstraction
    # leak, but oh well. fix this by serving test data from a test controller?
    Crack::XML.parse(xml)
  end

  test "test_transform_venue" do

    name = "Hollywood Bowl"
    phone = "3238485100"
    address = "8430 Sunset Boulevard"
    postal_code = "90210"
    city = "West Hollywood"
    state = "CA"
    country = "US"
    venue_link = "http://someurl.com"

    xml = %{
		  <venue>
			  <id>1596</id>
			  <owned>OWNED</owned>
			  <name>#{name}</name>
			  <city>#{city}</city>
			  <state>#{state}</state>
			  <country>#{country}</country>
			  <address>#{address}</address>
			  <postal_code>#{postal_code}</postal_code>
			  <phone>#{phone}</phone>
			  <permitted_items></permitted_items>
			  <venue_link>#{venue_link}</venue_link>
		  </venue>}
    venue_data = parse_xml(xml)
    venue = LiveNationAPI::Transformer.transform_venue(venue_data['venue'])

    assert_equal name, venue.name
    assert_equal city, venue.city
    assert_equal state, venue.state
    assert_equal phone, venue.phone

  end

  test "test_transform_artist" do 
    name = "Neil Young"
    link = "http://livenation.com/link"
    id = "301901"
    amg_id = "23422"

    artist_xml = %{
			<artist>
				<artist_link>#{link}</artist_link>
				<id>#{id}</id>
				<amg_id>#{amg_id}</amg_id>
				<name>#{name}</name>
				<genre></genre>
			</artist>
          }

    artist_data = parse_xml(artist_xml)['artist']
    artist = LiveNationAPI::Transformer.transform_artist(artist_data)
    assert_equal name, artist.name
  end

  test "test transform" do
    sample_file = File.join(this_dir(), 'live_nation_sample_data.xml')
    input_xml_data = File.open(sample_file) { |f| f.read }
    ## Crack is the parsing library used in httparty. definitely an abstraction
    ## leak, but oh well. fix this by serving test data from a test controller?
    xml_data = parse_xml(input_xml_data)
    events = LiveNationAPI::Transformer.transform(xml_data)

    assert_equal 2, events.length

    lupe_at_house_of_blues = events[0]
    house_of_blues = lupe_at_house_of_blues.venue
    assert_equal "House of Blues Sunset Strip", house_of_blues.name
    hob_artists = lupe_at_house_of_blues.artists
    assert_equal 2, hob_artists.length
    lupe = hob_artists[0]
    assert_equal "Lupe Fiasco", lupe.name
    bob = hob_artists[1]
    assert_equal "B.o.B.", bob.name

    ok_go_in_philly = events[1]
    theatre_of_living_arts = ok_go_in_philly.venue
    assert_equal "Theatre of the Living Arts", theatre_of_living_arts.name

    philly_artists = ok_go_in_philly.artists
    assert_equal 1, philly_artists.length
    ok_go = philly_artists[0]
    assert_equal "OK Go", ok_go.name

  end

end
