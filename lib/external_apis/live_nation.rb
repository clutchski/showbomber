#
# This module controls the interaction with the livenation.com API.
#
# http://developers.livenation.com/index.html
#

require 'httparty'


module LiveNationAPI

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

  class Transformer

    def self.transform_venue(venue_data)
      venue = Venue.new
      venue.name = venue_data['name']
      venue.city = venue_data['city']
      venue.address = venue_data['address']
      venue.state = venue_data['state']
      venue.phone = venue_data['phone']
      return venue
    end

    def self.transform_event(event_data)
      venue_data = event_data['venue']
      venue = transform_venue(venue_data)

      event = Event.new
      event.venue = venue

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
