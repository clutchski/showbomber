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


  def self.add_tag(artist, tag)
    transaction do 
      tag = Loader.load_tag(tag)
      if !artist.tags.include?(tag)
        artist.tags << tag
      end
    end
  end


  def self.load_tag(tag)
    transaction do 
      tag = Tag.find_or_create_by_name(tag.attributes)
      tag.save!
    end
    tag
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
    num_events = events.length
    Rails.logger.info "Event loading start. Loading #{num_events} events"

    error_count = 0
    transaction do 
      events.each do |event| 
        begin
          load_event(event)
        rescue => error
          Rails.logger.error "Unable to load event: #{event}: #{error}\n#{error.backtrace}"
          error_count += 1
        end
      end
    end
    Rails.logger.info "Event loading finished. #{error_count} of #{num_events} failed."
  end

end
