class AddActiveFieldToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :active, :boolean, :default => true, :null => false
    add_index :events, :active
  end

  def self.down
    remove_column :events, :active
  end
end
