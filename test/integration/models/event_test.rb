#
# This module contains integration tests for the Event model
#

require 'test_helper'


class EventTest < ActiveSupport::TestCase

  test "Artist tags roll up to the event." do
    # Create tags.
    folk = Factory.create(:tag, {:name => 'folk'})
    rock = Factory.create(:tag, {:name => 'rock'})
    indie = Factory.create(:tag, {:name => 'indie'})

    # Create artists.
    joe = Factory.create(:artist, {:name => 'Joe', :tags => [folk, rock]})
    jim = Factory.create(:artist, {:name => 'Jim', :tags => [indie, rock]})

    # Create event.
    event = Factory.create(:event, {:artists => [joe, jim]})


    # Assert the event has the expected tags.
    expected_tags = [folk, rock, indie]
    assert_equal expected_tags.length, event.tags.length
    expected_tags.each do |t|
      assert event.tags.include?(t)
    end
  end

  test "events can be found with the scope by_artist" do
    artist = Factory.create(:artist)
    assert_not_nil artist.id

    assert Event.by_artist(artist).all().empty?

    num_events = 3
    num_events.times.each do |i| 
      event = Factory.create(:event, {:artists => [artist]})
    end

    events = Event.by_artist(artist).all()
    assert !events.empty?
    assert_equal num_events, events.size
    events.each do |e| 
      assert e.artists.include?(artist)
    end
  end

  test "We can filter upcoming events by tags." do
    folk_name = '__folk_test_filter_upcoming__'
    rock_name = '__rock_test_filter_upcoming__'
    folk = Factory.create(:tag, {:name => folk_name})
    rock = Factory.create(:tag, {:name => rock_name})

    stones = Factory.create(:artist, {:name => 'Stones', :tags => [rock]})
    joni = Factory.create(:artist, {:name => 'Joni', :tags => [folk]})
    odb = Factory.create(:artist, {:name => 'ODB'})

    joni_event = Factory.create(:event, {:artists => [joni]})
    stones_event = Factory.create(:event, {:artists => [stones]})
    odb_event = Factory.create(:event, {:artists => [odb]})
    all_events = [joni_event, stones_event, odb_event]

    # Assert all are in upcoming events
    upcoming_events = Event.get_upcoming_events()
    all_events.each do |e|
      assert upcoming_events.include?(e)
    end

    folk_events = Event.get_upcoming_events(day_count=nil, tags => [folk_name])
    [stones_event, odb_event].each do |e|
      assert !folk_events.include?(e), "Folk events shouldnt include #{e}"
    end

    hip_hop_events = Event.get_upcoming_events(day_count=nil, tags => ['hip-hop'])
    all_events.each do |e|
      assert !hip_hop_events.include?(e)
    end
  end

  test "events in the past aren't included in upcoming events" do
    days_ago = [10, 5, 1]
    past_events = days_ago.collect do |d| 
      Factory.create(:event, :start_date => d.days.ago)
    end

    upcoming_events = Event.get_upcoming_events()

    past_events.each do |e|
      assert !upcoming_events.include?(e), 
        "upcoming events shouldn't include past event: #{e.start_date}"
    end
  end

  test "assert today's events are included in upcoming events" do
    show_times = [6, 12, 17, 23]
    midnight = DateTime.now.midnight
    events = show_times.collect do |t|
      start_date = midnight + (60*60 * t)
      Factory.create(:event, :start_date => start_date)
    end

    upcoming_events = Event.get_upcoming_events()

    events.each do |e|
      assert upcoming_events.include?(e)
    end
  end

  test "inactive events are filtered from upcoming events" do
      inactive_event = Factory.create(:event, :active => false)
      active_event = Factory.create(:event)

      upcoming_events = Event.get_upcoming_events()

      assert upcoming_events.include? active_event
      assert !upcoming_events.include?(inactive_event), "no inactive events"
  end

end
