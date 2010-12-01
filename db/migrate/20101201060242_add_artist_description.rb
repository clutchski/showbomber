class AddArtistDescription < ActiveRecord::Migration
  def self.up
    add_column :artists, :description, :text
  end

  def self.down
    remove_column :artists, :description
  end
end
