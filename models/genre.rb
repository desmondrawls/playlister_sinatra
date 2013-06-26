class Genre
  attr_accessor :name, :song, :artist

  GENRES = []

  def initialize
    GENRES << self
    self.song = []
    self.artist = []
  end

  def self.reset_genres
    GENRES.clear
  end

  def name_for_url
    self.name.split.join.downcase
  end

  def self.find_by_name(name)
    self.all.select{|genre| genre.name_for_url == name}
  end

  def self.all
    GENRES
  end

end
