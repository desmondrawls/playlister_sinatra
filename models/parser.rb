# puts Song.all

class Parse
    @@our_data = Dir.entries("./data").drop(2)

    def parse
      @@our_data.each do |song|
        throwaway_song = Song.new
        throwaway_song.name = song.split(" - ").at(1).split("[").first.strip
        
        genre_name = song.split("[").last.split("]").first
        genre = Genre.all.select{|genre| genre.name == genre_name}.first
        if genre
            throwaway_song.genre = genre
        else
            genre = Genre.new
            genre.name = genre_name
            throwaway_song.genre = genre
        end
        

        
        artist_name = song.split(" - ").first.to_s
        artist = Artist.all.select{|artist| artist.name == artist_name}.first
        if artist == nil
            artist = Artist.new
            artist.name = artist_name
            artist.add_song(throwaway_song)
        else
            artist.add_song(throwaway_song)
        end

        throwaway_song.artist = artist
      end
    end
end

# parser = Parse.new.parse
