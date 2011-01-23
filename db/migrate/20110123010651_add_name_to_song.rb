class AddNameToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :name, :text
  end

  def self.down
    remove_column :songs, :name
  end
end
