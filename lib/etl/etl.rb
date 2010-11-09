#
# This module contains the showbomber etl control script.
#


require 'lib/apis/wfmu.rb'
require 'lib/apis/freebase.rb'
require 'lib/etl/loader.rb'


class ETL < ActiveRecord::Base

  @logger
    
  def self.run
    @logger = Rails.logger
    begin
      @logger.info "ETL import started."
      self.load_events
      self.load_artist_tags
    rescue => e
      @logger.error "Fatal ETL Error: #{e.message}: #{e.backtrace}"
      raise e
    end
    @logger.info "ETL import finished"
  end

  def self.load_events
    @logger.info "Loading WFMU events"
    events = WFMU::get_events
    Loader.load_events(events)
    @logger.info "Finished loading WFMU events"
  end

  def self.load_artist_tags
    @logger.info "Loading artist tags"
    artists = Artist.includes(:tags).all()
    artists.each do |a|
      tags = []
      begin
        tags = Freebase.music_genres(a.name)
      rescue => e
        @logger.error("Couldn't fetch genre for #{a.name}: #{e.backtrace}")
      end
      tags.each do |t|
        tag = Tag.new(:name => t)
        transaction do 
          tag = Loader.load_tag(tag)
          if !a.tags.include?(tag)
            a.tags << tag
          end
        end
      end
    end
    @logger.info "Done loading artist tags"
  end

end


if __FILE__ == $0
  ETL::run
end
