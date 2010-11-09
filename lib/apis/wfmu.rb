#
# This module controls the interactions with the "WFMU
# Arbitrary Guide to Popular Culture"
#
# http://www.wfmu.org/arbguide.php
#

require 'active_support/core_ext'
require 'open-uri'
require 'nokogiri'

module WFMU

  def self.get_events
    data = Extractor.extract
    events = Transformer.transform data
    return events
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

    @@NJ_CITIES = ['hoboken']
    @@NEW_YORK_CITY_ALIASES = ['new york city', 'nyc']

    def self.normalize(string)
      # http://stackoverflow.com/questions/225471
      #   /how-do-i-replace-accented-latin-characters-in-ruby
      #e.g. nbsp -> space
      string.mb_chars.normalize(:kc).strip
    end

    def self.parse_artist(artist_cell)
      # sometimes WFMU includes miscellaneous information in other information
      # in parens, like "Pavement (Reunion!)" or "Joe Blow (From Some Band)"
      # so get rid of that
      artist = artist_cell.split('(', 2)[0]
      self.normalize(artist)
    end

    def self.parse_artists(artists_cell)
      # The first line contains the artists, others contain misc info.
      artist_line = artists_cell.content.split("\n", 2)[0]

      # Artists are usually delimited with commas, but occasionally slashes
      # are used - see Case 30.
      delimiter = artist_line.include?(',') ? ',' : '/'

      artist_line.split(delimiter).collect{|a| parse_artist(a) }
    end

    def self.parse_address(address_cell)
      address = self.normalize(address_cell.text).strip.to_s

      return nil if address.nil? or address.empty?

      # WFMU stores addresses very informally, including cross streets,
      # neighbourhoods, etc. try to strip everything but the street
      # address.
      splits = [" at ", ",", " b/t", " btwn", " --", " ("]

      return splits.inject(address) do |m, s|
        (m.split(s)[0]).strip
      end
    end

    def self.parse_venue_name(venue_cell)
      # A strange one-off. WFMU stores the name of "Le Poisson Rouge" as
      # "(le) Poiss..", which messes up other parens parsing, so just hacking
      # it out here. Case #31.
      content = venue_cell.content
      if content.downcase.starts_with?("(le) poisson rouge")
        return "Le Poisson Rouge"
      end
      # Ignore the "(website)" link.
      name = content.split('(', 2)[0]
      return self.normalize(name).strip
    end
 
    def self.parse_venue_website(venue_cell)
      url_nodeset = venue_cell.css('a')
      return (url_nodeset.empty?) ? nil : url_nodeset.first['href']
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
      cost = self.normalize(cost_cell.content).strip
      return 0 if cost.downcase.include? 'free'
      # remove the dollar sign
      return cost[1..-1].to_i
    end

    def self.str_to_date(str, format)
      begin
        return DateTime.strptime(str, format)
      rescue => e
        msg = "error parsing '#{str}' with fmt '#{format}': #{e.message}"
        raise Exception.new(msg)
      end
    end

    def self.parse_date(date_cell, time_cell)
      date = self.normalize(date_cell.content).to_s
      time = self.normalize(time_cell.content).to_s

      date_format = "%a %m/%d"

      return str_to_date(date, date_format) if time.blank?

      # Yes, this is real.
      time = time.downcase.include?("noon") ? "12 PM" : time
      
      # For ranges, just show the start time for now.
      time = (time.split("-", 2)[0]).strip

      date_no_mins = "#{date_format} %I %p"
      date_with_mins = "#{date_format} %I:%M %p"

      date_str = self.normalize("#{date} #{time}").strip.to_s
      cur_format = date_str.include?(":") ? date_with_mins : date_no_mins

      return str_to_date(date_str, cur_format)
    end

    def self.get_state(city)
      if city and @@NJ_CITIES.include? city.downcase
        return "New Jersey"
      else
        return "New York"
      end
    end

    def self.normalize_city(city)
      if not city or @@NEW_YORK_CITY_ALIASES.include?(city.downcase)
        return "New York"
      else
        return city
      end
    end

    def self.parse_venue(cells)
      aliased_city = parse_venue_city(cells[@@CITY_CELL])
      city = normalize_city(aliased_city)
      state = self.get_state(city)
      { :name    => parse_venue_name(cells[@@VENUE_CELL]),
        :address => parse_address(cells[@@ADDRESS_CELL]),
        :city    => city,
        :state   => state,
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
      events = self.parse(html)
      return events
    end
  end

  # 
  # This class transforms the feed data into business objects.
  #
  class Transformer

    @@IGNORE_VENUES = ['THE STONE']

    def self.transform_venue(venue_data)
      Venue.new do |v|
        v.name = venue_data[:name]
        v.address = venue_data[:address]
        v.city = venue_data[:city]
        v.state = venue_data[:state]
        v.phone = venue_data[:phone]
        #FIXME: add website
      end
    end

    def self.transform_event(event_data)
      venue = transform_venue(event_data[:venue])
      artists = event_data[:artists].collect{|name| Artist.new(:name=>name)}

      Event.new do |e|
        e.min_cost = event_data[:cost]
        e.start_date = event_data[:date]
        e.artists = artists
        e.venue = venue
      end
    end

    def self.transform(events_data)
      events = events_data.collect{|e| self.transform_event(e)}
      return events.select{|e| self.include_event(e)}
    end

    def self.include_event(event)
      if @@IGNORE_VENUES.include? event.venue.name.upcase
        return false
      end
      return true
    end

  end
end

if __FILE__ == $0
  WFMU::run()
end