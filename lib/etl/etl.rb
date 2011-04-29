#
# This module contains the showbomber etl control script.
#


require 'lib/apis/wfmu.rb'
require 'lib/apis/freebase.rb'
require 'lib/etl/loader.rb'
require 'lib/etl/objectifier.rb'
require 'lib/etl/transformer/tags.rb'


module ETL 

  class Controller < ActiveRecord::Base

    @logger
      
    def self.run
      @logger = Rails.logger
      begin
        @logger.info "ETL import started."
        self.load_events
        self.load_artist_info
      rescue => e
        @logger.error "Fatal ETL Error: #{e.message}: #{e.backtrace}"
        raise e
      end
      @logger.info "ETL import finished"
    end

    def self.load_events
      @logger.info "Loading WFMU events"
      event_data = WFMU::Extractor.extract
      events = Objectifier.objectify_events(event_data)
      Loader.load_events(events)
      @logger.info "Finished loading WFMU events"
    end

    def self.load_artist_info
      artists = Artist.includes(:tags).all()

      @logger.info "Loading artist tags for #{artists.length} artists"

      no_info_artists = []

      artists.each do |a|
        @logger.info "loading info for #{a.name}"
        tags = []
        description = ''
        songs = []
        begin
          info = Freebase.artist(a.name)
          tags = info[:genres] || []
          description = info[:description] || ''
          songs = info[:songs] || []

        rescue => e
          no_info_artists << a.name
          @logger.debug("Couldn't fetch artist info for #{a.name}: #{e.backtrace}")
        end

        if description != a.description
          a.description = description
          a.save!
        end

        tags = ETL::Transformer::Tags.transform_tags(tags)
        tags.each do |t|
          tag = Tag.new(:name => t)
          Loader.add_tag(a, tag)
        end


        songs.each do |s|
          song = Song.new(:name => s)
          Loader.add_song(a, song)
        end

      end
      @logger.info "Done loading artist tags"
      @logger.warn "Couldn't log info for artists: #{no_info_artists.join('|')}"
    end
  end

  def self.run
    return Controller.run
  end

end


if __FILE__ == $0
  Rails.logger = Logger.new(STDOUT)
  Rails.logger.level = Logger::INFO

  ETL::Controller.run
end
