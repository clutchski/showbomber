#
# This library contains the Freebase API.
#

require 'rubygems'
require 'ken'

module Freebase


  def self.artist_by_name(artist_name)
    topic = self.get_artist_topic(artist_name)
    return self.parse_topic_info(topic)
  end


  def self.artist_by_id(artist_topic_id)
    topic = Ken::Topic.get(artist_topic_id)
    return self.parse_topic_info(topic)
  end

  private

  def self.parse_topic_info(topic)
    { :description => topic.description,
      :genres => self.music_genres(topic),
      :songs => self.get_songs(topic),
      :freebase_id => topic.id
    }
  end

  def self.music_genres(artist_topic)
    return self.get_attributes(artist_topic, '/music/artist/genre', 3)
  end

  def self.get_songs(artist_topic)
    return self.get_attributes(artist_topic, '/music/artist/track', 3)
  end

  def self.get_attributes(topic, attribute, count)
    attrs = topic.attribute(attribute).values.collect{|a| a.name}.uniq
    return attrs[0 .. count-1]
  end

  def self.get_artist_topic(artist_name)
    id = self.get_artist_topic_id(artist_name)
    return Ken::Topic.get(id)
  end

  def self.get_artist_topic_id(artist_name)
    type = '/music/artist'
    params = {:id=> nil, :name => artist_name, :type => type, :limit => 2}
    results = Ken.session.mqlread([params]).select do |topic_info|
      # Only care about english results
      topic_info['id'].starts_with? '/en'
    end
    if results.empty?
      raise Exception("No artist found with name [#{artist_name}]")
    elsif results.length > 1
      raise Exception("Multiple artists [#{type}] found with name [#{artist_name}]")
    else
      return results.first['id']
    end
  end

end
