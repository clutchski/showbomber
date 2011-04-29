class AddFreebaseIdToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :freebase_id, :text
  end

  def self.down
    remove_column :artists, :freebase_id
  end
end
