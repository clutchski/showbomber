#
# This library contains the Freebase API.
#

require 'rubygems'
require 'ken'

module Freebase

  def self.music_genres(artist)
    genre = '/music/artist/genre'
    return self.get(artist).attribute(genre).values.collect{|g| g.name}
  end

  private

  def self.get(resource)
    url = '/en/' + self.to_resource(resource)
    return Ken.get(url)
  end

  def self.to_resource(name)
    while name.include?(' ')
      name.sub!(' ', '_')
    end
    return name.downcase
  end
end
