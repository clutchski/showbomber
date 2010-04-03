class InitialMigration < ActiveRecord::Migration
  def self.up

    create_table :artists do |t|
      t.string :name
      t.timestamps
    end
    add_index(:artists, :name)

    create_table :venues do |t|
      t.string :name
      t.string :address1
      t.string :city
      t.string :state
      t.timestamps
    end
    add_index(:venues, :city)

    create_table :events do |t|
      t.integer     :venue_id
      t.datetime    :start_date
      t.timestamps
    end
    add_index(:events, :venue_id)
    add_index(:events, :start_date)

    create_table :artists_events, :id => false do |t|
      t.integer :event_id
      t.integer :artist_id
    end
    add_index(:artists_events, [:event_id, :artist_id], {:unique=>true})


  end #up

  def self.down

    drop_table :artists_events
    drop_table :events
    drop_table :artists
    drop_table :venues

  end
end
