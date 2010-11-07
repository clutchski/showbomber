class InitialMigration < ActiveRecord::Migration
  def self.up

    create_table :artists do |t|
      t.string :name
      t.timestamps
    end
    add_index(:artists, :name)

    create_table :tags do |t|
      t.string :name
      t.timestamps
    end
    add_index(:tags, :name)

    create_table :artists_tags, :id => false do |t|
      t.integer :artist_id
      t.integer :tag_id
    end
    add_index(:artists_tags, [:artist_id, :tag_id], {:unique=>true})

    create_table :venues do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.timestamps
    end
    add_index(:venues, :city)

    create_table :events do |t|
      t.integer     :venue_id
      t.datetime    :start_date
      t.integer     :min_cost
      t.integer     :max_cost
      t.timestamps
    end
    add_index(:events, :venue_id)
    add_index(:events, :start_date)

    create_table :artists_events, :id => false do |t|
      t.integer :event_id
      t.integer :artist_id
    end
    add_index(:artists_events, [:event_id, :artist_id], {:unique=>true})

    create_table :songs do |t|
      t.integer :artist_id
      t.string  :url
    end
    add_index(:songs, :artist_id)

  end #up

  def self.down

    drop_table :songs
    drop_table :artists_events
    drop_table :events
    drop_table :artists_tags
    drop_table :tags
    drop_table :artists
    drop_table :venues

  end
end
