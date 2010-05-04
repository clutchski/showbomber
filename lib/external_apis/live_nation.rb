#
# This module controls the interaction with the livenation.com API.
#
# http://developers.livenation.com/index.html
#

require 'httparty'


module LiveNationAPI


 #
 # This class hits the live nation webservice, and returns a hash of
 # the response content.
 # 
 class Extractor

    include HTTParty

    base_uri "http://developers.livenation.com"
    format :xml

    @@url="/index.php"
    @@args="/allEvents/auth/a4473318605a9b2b9c33afa0b3e246fa"

    def self.extract(test_mode=false)
      test_mode_code = test_mode ? '1' : '0'
      args = @@args + "/testMode/#{test_mode_code}"
      get(@@url, :query => {"t"=> args})
    end
  end


  # 
  # This class transforms the live nation feed data into business objects.
  #
  class Transformer

    def self.transform_venue(venue_data)
      venue = Venue.new
      venue.name = venue_data['name']
      venue.address = venue_data['address']
      venue.city = venue_data['city']
      venue.state = venue_data['state']
      venue.postal_code = venue_data['postal_code']
      venue.phone = venue_data['phone']
      return venue
    end

    def self.transform_artist(artist_data)
      artist = Artist.new
      artist.name = artist_data["name"]
      return artist
    end

    def self.transform_event(event_data)

      # parse venue
      venue_data = event_data['venue']
      venue = transform_venue(venue_data)

      # parse artists
      artists = []
      %w{artists_headline artists_other}.each do |key|
        artists_set_data = event_data[key]
        next if artists_set_data.nil?
        artists_data = artists_set_data['artist']
        if !artists_data.is_a? Array
          artists_data = [artists_data]
        end
        artists += artists_data.collect{|a| transform_artist(a)}
      end

      # parse start date
      start_date_data = "#{event_data['date']} #{event_data['time']}"
      # format: "5-2-2010 21:00:00"
      start_date_format = "%m-%d-%Y %H:%M:%S"
      start_date = DateTime.strptime(start_date_data, start_date_format)

      event = Event.new
      event.venue = venue
      event.artists = artists
      event.start_date = start_date
      return event
    end

    def self.transform(live_nation_data)
      events_data = live_nation_data['result']
      return events_data['event'].collect{|e| transform_event(e)}
    end

  end

  class Loader < ActiveRecord::Base


  end
 
end
