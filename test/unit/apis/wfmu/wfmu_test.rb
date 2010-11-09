#
# This module contains test for the wfmu events site.
#

# stdlib
require 'test_helper'

# project
require 'lib/apis/wfmu.rb'


class WFMUExtractorTest < ActiveSupport::TestCase

  def this_dir
    File.dirname(__FILE__)
  end

  def this_year
    DateTime.now.year
  end

  def read_sample_data(path)
    sample_file = File.join(this_dir(), 'test_data', path)
    File.open(sample_file) { |f| f.read }
  end

  test "assert we don't show events playing at 'The Stone'. Case 34" do
    html = read_sample_data("wfmu_case_34_omit_venue_the_stone.html")
    event_data = WFMU::Extractor.parse(html)
    events = WFMU::Transformer.transform(event_data)
    assert_equal 1, events.length
  end

  test "assert venue names starting with parens can be parsed. Case 31" do
    html = read_sample_data("wfmu_case_31_venue_starting_with_parens.html")
    events = WFMU::Extractor.parse(html)
    assert_equal 1, events.length
    event = events.first
    venue = event[:venue]
    assert_equal "Le Poisson Rouge", venue[:name]
  end

  test "test slash delimited artists are parsed. case 30" do
    html = read_sample_data("wfmu_case_30_slash_delimited_artists.html")
    events = WFMU::Extractor.parse(html)
    assert_equal 1, events.length

    event = events.first
  
    artists = event[:artists]

    expected_names = %w{Trident Immolith Evoken Neldoreth}

    assert !artists.empty?
    assert_equal expected_names.length, artists.length

    artists.each do |a|
      assert expected_names.include? a
    end
  end
 
  
  test "test extractor works" do
    sample_html = read_sample_data("wfmu_example.html")
    events = WFMU::Extractor.parse(sample_html)
    assert_equal 3, events.length

    # parse terminal 5 event

    terminal_5 = events[0]
    assert_equal DateTime.new(this_year, 05, 18, 19), terminal_5[:date] 
    assert_equal 0, terminal_5[:cost] 
    terminal_5_artists = terminal_5[:artists]
    assert_not_nil terminal_5_artists
    assert_equal 1, terminal_5_artists.length
    assert_equal "Public Image Limited", terminal_5_artists[0]

    terminal_5_venue = terminal_5[:venue]
    assert_equal "Terminal 5", terminal_5_venue[:name]
    assert_equal "http://www.terminal5nyc.com/", terminal_5_venue[:website]
    assert_equal "289 Kent Ave.", terminal_5_venue[:address]
    assert_equal "New York", terminal_5_venue[:city]
    assert_equal "New York", terminal_5_venue[:state]
    assert_nil terminal_5_venue[:phone]

    # parse union hall event

    union_hall = events[1]
    assert_equal DateTime.new(this_year, 05, 18, 20), union_hall[:date] 
    assert_equal 15, union_hall[:cost] 
    union_hall_artists = union_hall[:artists]
    assert_not_nil union_hall_artists
    assert_equal 2, union_hall_artists.length
    assert_equal "Neil Halstead", union_hall_artists[0]
    assert_equal "J. Wise", union_hall_artists[1]

    union_hall_venue = union_hall[:venue]
    assert_equal "Union Hall", union_hall_venue[:name]
    assert_equal "http://unionhallny.com/", union_hall_venue[:website]
    assert_equal "702 Union St", union_hall_venue[:address]
    assert_equal "Brooklyn", union_hall_venue[:city]
    assert_equal "New York", union_hall_venue[:state]
    assert_equal "718-638-4400", union_hall_venue[:phone]

    # parse knitting factory event

    knitting_factory = events[2]
    assert_equal DateTime.new(this_year, 05, 19, 19,30), knitting_factory[:date] 
    assert_equal 12, knitting_factory[:cost] 
    knitting_factory_artists = knitting_factory[:artists]
    assert_equal 3, knitting_factory_artists.length
    assert_equal "Spectrum", knitting_factory_artists[0]
    assert_equal "Cheval Sombre", knitting_factory_artists[1]
    assert_equal "The Vacant Lots", knitting_factory_artists[2]

    knitting_factory_venue = knitting_factory[:venue]
    assert_equal "Knitting Factory Brooklyn", knitting_factory_venue[:name]
    assert_nil knitting_factory_venue[:address]
    assert_equal "New York", knitting_factory_venue[:city]
    assert_equal "New York", knitting_factory_venue[:state]
    assert_nil knitting_factory_venue[:phone]
    assert_nil knitting_factory_venue[:website]

  end
end
