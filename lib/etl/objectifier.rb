
module ETL

  #
  # This module transforms hashes into business objects.
  #
  module Objectifier

    def self.objectify_venue(venue_data)
      Venue.new do |v|
        v.name = venue_data[:name]
        v.address = venue_data[:address]
        v.city = venue_data[:city]
        v.state = venue_data[:state]
        v.phone = venue_data[:phone]
        #FIXME: add website
      end
    end

    def self.objectify_event(event_data)
      venue = objectify_venue(event_data[:venue])
      artists = event_data[:artists].collect{|name| Artist.new(:name=>name)}

      Event.new do |e|
        e.min_cost = event_data[:cost]
        e.start_date = event_data[:date]
        e.artists = artists
        e.venue = venue
      end
    end

    def self.objectify_events(events_data)
      return events_data.collect{|e| self.objectify_event(e)}
    end
  end
end
