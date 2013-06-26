class Song
  attr_accessor :name, :artist
  attr_reader :genre

  SONGS = []

  def initialize
    SONGS << self
  end

  def self.reset_songs
    SONGS.clear
  end

  def self.all
    SONGS
  end

  def name_for_url
    self.name.split.join.downcase
  end

  def self.find_by_name(song_name)
    self.all.select{|song| song.name_for_url == song_name}
  end

  def genre=(genre)
    @genre = genre
    genre.song << self
  end

end