module ETL
  module Transformer

    # This module transforms the crazy world of internet tags into
    # something usable for Showbomber.
    module Tags

      @synonyms = {'rap' => 'hip-hop', 
                   'hip hop' => 'hip-hop',
                   'heavy metal' => 'metal',
                   'hard rock' => 'rock',
                   'rhythm and blues' => 'r&b',
                   'synthpop' => 'pop',
                   'popular' => 'pop',
                   'blues-rock' => 'rock',
                   'dub' => 'reggae',
                   'breakbeat' => 'electronic',
                   'thrashcore' => 'hardcore',
                   'funk' => 'r&b',
                   'brasileira' => 'latin',
                   'lounge' => 'electronic',
                   'electro' => 'electronic',
                   'skate' => 'alternative',
                   'grunge' => 'alternative',
                   'thrash' => 'hardcore',
                   'metalcore' => 'hardcore',
                   'chamber' => 'classical',
                   'techno' => 'electronic',
                   'industrial' => 'electronic',
                   'garage rock' => 'garage',
                   'alternative country' => 'indie',
                   'power pop' => 'pop',
                   'no wave' => 'punk',
                   'european classical' => 'classical',
                   'latin american' => 'latin',
                   'experimental rock' => 'rock',
                   'post-rock' => 'rock',
                   'rapcore' => 'hip-hop',
                   'hyphy' => 'hip-hop',
                   'shoegazing' => 'indie',
                   'trip hop' => 'electronic',
                   'rock and roll' => 'rock',
                   'dubstep' => 'electronic',
                   'new wave' => 'punk',
                   'ska' => 'reggae',
                   'microhouse' => 'electronic'
                   }

      @contains = {'punk' => 'punk',
                   'electro' => 'electronic',
                   'hip hop' => 'hip-hop',
                   ' rap' => 'hip-hop',
                   ' rock' => 'rock',
                   'metal' => 'metal',
                   'thrash' => 'hardcore',
                   'funk' => 'funk',
                   'jazz' => 'jazz',
                   ' pop' => 'pop',
                   ' house' => 'electronic',
                   ' dance' => 'electronic',
                   ' folk' => 'folk',
                   'techno' => 'electronic',
                   'ambient' => 'electronic',
                   '2 tone' => 'reggae'
                   }


      @splits = ['psychadelic rock', 'folk rock', 'indie rock', 'indie folk'] +
                ['indie pop']


      @ignored = %w{d-beat street folktronica aggrotech turntablism}
      @ignored += %w{dark synthpunk dance-punk glam grrrl riot}
      @ignored += %w{tone 2 jangle art gothic new roll house minimal glitch}
      @ignored += %w{grunge power no wave free european american canadian}
      @ignored += ['youth crew', 'tropicalismo', 'experimental', 'christian']
      @ignored += ['riot grrrl', 'avant-garde', 'experimental classic']

      def self.transform_tags(tags)
        tags.collect{|t| self.transform(t)}.flatten.uniq
      end

      def self.transform(tag)
        tag.downcase!

        tag = self.strip_music_suffix(tag)

        return [] if @ignored.include?(tag)

        synonym = @synonyms[tag]
        return [synonym] if !synonym.nil?

        if @splits.include?(tag)
          return tag.split(' ')
        end

        @contains.each_pair do |substring, sub_tag|
          return [sub_tag] if tag.include?(substring)
        end

       return [tag]
      end
      
      def self.strip_music_suffix(tag)
        suffix = ' music'
        if tag.ends_with?(suffix):
          tag = tag[0 .. -(suffix.length+1)]
        end
        return tag
      end
    end
  end
end
