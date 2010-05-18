#
# This module controls the interactions with the "WFMU
# Arbitrary Guide to Popular Culture"
#
# http://www.wfmu.org/arbguide.php
#

require 'rubygems'
require 'active_support'
require 'open-uri'
require 'nokogiri'


module WFMU

  def self.run
    data = Extractor.extract
    puts data.inspect
  end

  class Extractor

    @@URL = "http://www.wfmu.org/arbguide.php"

    @@DATE_CELL     = 0
    @@COST_CELL     = 1
    @@ARTIST_CELL   = 2
    @@TIME_CELL     = 3
    @@VENUE_CELL    = 4
    @@ADDRESS_CELL  = 5
    @@CITY_CELL     = 6
    @@PHONE_CELL    = 7

    def self.normalize(string)
      # http://stackoverflow.com/questions/225471
      #   /how-do-i-replace-accented-latin-characters-in-ruby
      #e.g. nbsp -> space
      string.mb_chars.normalize.strip
    end

    def self.parse_artists(artists_cell)
      # the first line contains the artists, others contain age info, etc.
      artist_line = artists_cell.content.split("\n", 2)[0]
      return artist_line.split(',').collect{|a| normalize(a)}
    end

    def self.parse_address(address_cell)
      address = self.normalize(address_cell.text).strip
      # remove cross streets (e.g 200 5th at 2nd ave)
      address = address.split(" at ", 2)[0]
      return (address.nil? or address.empty?) ? nil : address
    end

    def self.parse_venue_name(venue_cell)
      # ignore the "(website)" link
      name = venue_cell.content.split('(', 2)[0]
      return self.normalize(name).strip
    end
 
    def self.parse_venue_website(venue_cell)
      url_nodeset = venue_cell.css('a')
      url = (url_nodeset.empty?) ? nil : url_nodeset.first['href']
    end

    def self.parse_venue_phone(phone_cell)
      phone = self.normalize(phone_cell.text).strip
      return (phone.empty?) ? nil : phone
    end

    def self.parse_venue_city(city_cell)
      city = self.normalize(city_cell.text).strip
      return (city.empty?) ? nil : city
    end

    def self.parse_cost(cost_cell)
      return self.normalize(cost_cell.content).strip
    end

    def self.parse_date(date_cell, time_cell)
      date = date_cell.content
      time = time_cell.content
      self.normalize("#{date} #{time}").strip
    end

    def self.parse_venue(cells)
      { :name    => parse_venue_name(cells[@@VENUE_CELL]),
        :address => parse_address(cells[@@ADDRESS_CELL]),
        :city    => parse_venue_city(cells[@@CITY_CELL]),
        :phone   => parse_venue_phone(cells[@@PHONE_CELL]),
        :website => parse_venue_website(cells[@@VENUE_CELL])
      }
    end

    def self.parse_row(row)
      cells = row.css('td')
      { :date    => parse_date(cells[@@DATE_CELL], cells[@@TIME_CELL]),
        :cost    => parse_cost(cells[@@COST_CELL]),
        :artists => parse_artists(cells[@@ARTIST_CELL]),
        :venue   => parse_venue(cells)
      }
    end

    def self.parse(html)
      doc = Nokogiri::HTML(html)
      rows = doc.css('table tr')
      rows.shift # drop the header row
      rows.collect {|row| self.parse_row row}
    end

    def self.extract
      html = open(@@URL)
      self.parse(html)
    end
  end

  ## 
  ## This class transforms the live nation feed data into business objects.
  ##
  #class Transformer

  #  def self.transform_venue(venue_data)
  #    venue = Venue.new
  #    venue.name = venue_data['name']
  #    venue.address = venue_data['address']
  #    venue.city = venue_data['city']
  #    venue.state = venue_data['state']
  #    venue.postal_code = venue_data['postal_code']
  #    venue.phone = venue_data['phone']
  #    return venue
  #  end

  #  def self.transform_artist(artist_data)
  #    artist = Artist.new
  #    artist.name = artist_data["name"]
  #    return artist
  #  end

  #  def self.transform_event(event_data)

  #    # parse venue
  #    venue_data = event_data['venue']
  #    venue = transform_venue(venue_data)

  #    # parse artists
  #    artists = []
  #    %w{artists_headline artists_other}.each do |key|
  #      artists_set_data = event_data[key]
  #      next if artists_set_data.nil?
  #      artists_data = artists_set_data['artist']
  #      if !artists_data.is_a? Array
  #        artists_data = [artists_data]
  #      end
  #      artists += artists_data.collect{|a| transform_artist(a)}
  #    end

  #    # parse start date
  #    start_date_data = "#{event_data['date']} #{event_data['time']}"
  #    # format: "5-2-2010 21:00:00"
  #    start_date_format = "%m-%d-%Y %H:%M:%S"
  #    start_date = DateTime.strptime(start_date_data, start_date_format)

  #    event = Event.new
  #    event.venue = venue
  #    event.artists = artists
  #    event.start_date = start_date
  #    return event
  #  end

  #  def self.transform(live_nation_data)
  #    events_data = live_nation_data['result']
  #    return events_data['event'].collect{|e| transform_event(e)}
  #  end

  #end

end

if $0 == __FILE__
  data = WFMU::Extractor.extract
  puts data.inspect
end
