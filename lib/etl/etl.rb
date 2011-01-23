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
      @logger.info "Loading artist tags"
      artists = Artist.includes(:tags).all()
      artists.each do |a|
        tags = []
        description = ''
        begin
          info = Freebase.artist(a.name)
          tags = info[:genres] || []
          description = info[:description] || ''
        rescue => e
          @logger.error("Couldn't fetch artist info for #{a.name}: #{e.backtrace}")
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
      end
      @logger.info "Done loading artist tags"
    end
  end

  def self.run
    return Controller.run
  end

end


if __FILE__ == $0
  ETL::Controller.run
end
