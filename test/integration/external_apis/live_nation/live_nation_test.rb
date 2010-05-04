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
    # leak, but oh well. if this becomes a problem, we'll always parse with
    # Crack, and do custom http shit
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

  test "transform_event" do
    event_xml = %{
      <event>
      		<id>419652</id>
      		<source>LN</source>
      		<type>Music</type>
      		<status>Normal</status>
      		<title>Steppin Laser Tour: Lupe Fiasco</title>
      		<date>5-2-2010</date>
      		<time>21:00:00</time>
      		<doors>20:00:00</doors>
      		<description></description>
      		<venue>
      			<id>1596</id>
      			<owned>OWNED</owned>
      			<name>House of Blues Sunset Strip</name>
      			<city>West Hollywood</city>
      			<state>CA</state>
      			<country>US</country>
      			<address>8430 Sunset Boulevard</address>
      			<postal_code>90069</postal_code>
      			<phone>3238485100</phone>
      			<permitted_items></permitted_items>
      			<venue_link>http://www.livenation.com/venue/house-of-blues-sunset-strip-tickets/?c=api-001100</venue_link>
      		</venue>
      		<artists_headline>
      			<artist>
      				<artist_link>http://www.livenation.com/artist/lupe-fiasco-tickets/?c=api-001100</artist_link>
      				<id>620670</id>
      				<amg_id>741971</amg_id>
      				<name>Lupe Fiasco</name>
      				<genre></genre>
      			</artist>
      		</artists_headline>
      		<artists_other>
      			<artist>
      				<artist_link>http://www.livenation.com/artist/b-o-b-tickets/?c=api-001100</artist_link>
      				<id>301907</id>
      				<amg_id>926413</amg_id>
      				<name>B.o.B.</name>
      				<genre></genre>
      			</artist>
      		</artists_other>
      		<ticketing_source>no</ticketing_source>
      		<ticket_types>
      			<ticket>
      				<type>General Onsale</type>
      				<start_date>3-13-2010 10:00</start_date>
      			</ticket>
      		</ticket_types>
      		<ticket_link>http://www.livenation.com/edp/eventId/419652/?c=api-001100</ticket_link>
      		<last_modified>3-22-2010 20:37</last_modified>
      	</event>
    }
    event_data = parse_xml(event_xml)
    event = LiveNationAPI::Transformer.transform_event(event_data['event'])
    assert_equal DateTime.new(2010, 5, 2, 21), event.start_date

    # do a smoke test of the the artist parsing
    artists = event.artists
    assert_equal 2, artists.length
    assert_equal 'Lupe Fiasco', artists[0].name
    assert_equal 'B.o.B.', artists[1].name

    # do a smoke test of the venue parsing
    assert_equal "House of Blues Sunset Strip", event.venue.name


  end

  test "test transform" do
    sample_file = File.join(this_dir(), 'live_nation_sample_data.xml')
    input_xml_data = File.open(sample_file) { |f| f.read }

    xml_data = parse_xml(input_xml_data)
    events = LiveNationAPI::Transformer.transform(xml_data)

    assert_equal 2, events.length

    lupe_at_house_of_blues = events[0]
    house_of_blues = lupe_at_house_of_blues.venue
    assert_equal "House of Blues Sunset Strip", house_of_blues.name
    hob_artists = lupe_at_house_of_blues.artists
    assert_equal 2, hob_artists.length
    assert_equal "Lupe Fiasco", hob_artists[0].name
    assert_equal "B.o.B.", hob_artists[1].name

    ok_go_in_philly = events[1]
    theatre_of_living_arts = ok_go_in_philly.venue
    assert_equal "Theatre of the Living Arts", theatre_of_living_arts.name

    philly_artists = ok_go_in_philly.artists
    assert_equal 1, philly_artists.length
    assert_equal "OK Go", philly_artists[0].name

  end

end
