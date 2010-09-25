#
# This module is used to merge model objects from external sources
# into the database.
#

class Loader < ActiveRecord::Base


  def self.load_artist(artist)
    transaction do
      artist = Artist.find_or_create_by_name(artist.attributes)
      artist.save!
    end
    artist
  end


  def self.load_venue(venue)
    transaction do
      venue = Venue.find_or_create_by_name_and_city_and_state(venue.attributes)
      venue.save!
    end
    venue
  end

  def self.load_event(event)
    transaction do

        #FIXME: don't duplicate events

        event.venue = self.load_venue(event.venue)
        artists = event.artists.clone
        event.artists.clear

        artists.each do |artist| 
          artist = load_artist(artist)
          event.artists.push(artist)
        end

        existing_event = Event.where({:venue_id=>event.venue.id, :start_date=>
        event.start_date}).first

        event.save! unless existing_event
    end
  end

  def self.load_events(events)
    transaction do 
      events.each{|event| load_event(event)}
    end
  end

end
