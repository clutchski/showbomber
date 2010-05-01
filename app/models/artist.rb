class Artist < ActiveRecord::Base
  validates_presence_of :name

  has_and_belongs_to_many :events
  has_many :songs

  def get_song
    songs.first
  end

end
