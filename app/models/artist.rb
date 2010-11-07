class Artist < ActiveRecord::Base
  validates_presence_of :name

  has_and_belongs_to_many :events
  has_many :songs
  has_and_belongs_to_many :tags

  def get_song
    songs.first
  end

  def to_s
    "Artist<#{name}>"
  end

  def self.get_artists(tags)
    return Artist.joins(:tags).where('tags.name IN (?)', tags)
  end

end
