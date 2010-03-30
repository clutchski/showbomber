class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :name

      t.timestamps
    end

    create_table :venues do |t|
      t.string :name
      t.string :address1
      t.string :city
      t.string :state

      t.timestamps

    end
  end

  def self.down
    drop_table :artists
    drop_table :venues
  end
end
