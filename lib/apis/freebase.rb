#
# This library contains the Freebase API.
#

require 'rubygems'
require 'ken'

module Freebase

  def self.artist(artist)
    topic = self.get(artist)
    { :description => topic.description,
      :genres => self.music_genres(topic)
    }
  end

  def self.music_genres(topic)
    genre = '/music/artist/genre'
    genres = topic.attribute(genre).values.collect{|g| g.name}
    return genres[0 .. 3]
  end

  def self.description(artist)
    return self.get(artist).attribute('description')
  end

  private

  def self.get(resource)
    url = '/en/' + self.to_resource(resource)
    return Ken::Topic.get(url)
  end

  def self.to_resource(name)
    #FIXME: This is a naive implementation. It's working for most artist names
    # but it's failing for all with non-letter characters like " and '.
    while name.include?(' ')
      name.sub!(' ', '_')
    end
    return name.downcase
  end
end
