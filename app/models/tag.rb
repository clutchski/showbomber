class Tag < ActiveRecord::Base

  has_and_belongs_to_many :artists

  def name=(name)
    self[:name] = name.downcase if name
  end

  def self.get_approved_tags()
    tags = ['hip-hop', 'folk', 'indie', 'rock', 'punk', 'soul', 'pop',
    'country', 'techno', 'hardcore']
    return Tag.where('name in (?)', tags).all()
  end

  def self.synonym(tag)
    if ['rap', 'hip hop', 'hyphy', 'gangsta'].include? tag
      return 'hip-hop'
    end
    if ['heavy metal'].include? tag
      return 'metal'
    end
    if ['hard rock'].include? tag
      return 'rock'
    end
    if 'rhythm and blues' == tag
      return 'r&b'
    end
    if 'trip hop' == tag
      return 'trip-hop'
    end
    if tag.include? 'avant'
      return 'avant-garde'
    end
    if tag.include? 'electro'
      return 'electronic'
    end
    if tag == 'garage'
      return 'indie'
    end
    if tag == 'popular'
      return 'pop'
    end
    return nil
  end

  def self.ignore?(tag)
    genres = ['d-beat', 'street', 'folktronica','aggrotech', 'turntablism']
    genres += ['tropicalismo', 'body' ]
    return genres.include?(tag)
  end

  def self.normalize(tag)
    tag = tag.downcase

    return [] if self.ignore?(tag)

    music_suffix = ' music'
    if tag.ends_with?(music_suffix):
      tag = tag[0 .. -(music_suffix.length+1)]
    end

    if tag.starts_with? 'post'
      return nil #wtf is post-rock?
    end

    syn_tag = self.synonym(tag)
    tag = syn_tag ? syn_tag : tag

    tags = tag.split(' ') # e.g. "Folk Rock" -> ["Folk", "Rock"]

    tags = tags.collect do |t|
      syn = self.synonym(t)
      syn ? syn : t
    end
    return tags
  end

  def self.normalize_tags(tags)
    tags = tags.collect{|t| self.normalize(t)}.flatten.uniq
    return tags
  end

end
