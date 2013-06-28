require 'sinatra/base'
require_relative 'models/parser'
require 'youtube_search'
require './models/artist'
require './models/song'
require './models/genre'


module PlaylisterSite
  class App < Sinatra::Base
    def self.parse
      if Artist.all == []
        Parse.new.parse
      end
    end
    parse

    get '/' do
      erb :index
    end

    get '/songs/add' do
      erb :add_song
    end

    post '/songs/add' do
      @song_name = params[:song_name]
      @artist_name = params[:artist_name]
      @genre_name = params[:genre_name]
      
      @song = Song.new
      @song.name = @song_name

      @genre = Genre.all.select{|genre| genre.name == @genre_name}.first || 
        Genre.new.tap{|g| g.name = @genre_name}

      @song.genre = @genre

      @artist = Artist.all.select{|artist| artist.name == @artist_name}.first || 
        Artist.new.tap{|a| a.name = @artist_name}
      @artist.add_song(@song)
      
      @song.artist = @artist

      # @youtube_index = 0

      # @id = YoutubeSearch.search(@song.name.to_s + @artist.name.to_s)[@youtube_index]['video_id']

      redirect "/songs/#{@song.name.split.join.downcase}/video_picker/0"
    end

    get '/songs/:song/video_picker/:index' do
      @song = Song.find_by_name(params[:song]).first
      @artist = @song.artist
      @youtube_index = params[:index]
      @id = YoutubeSearch.search(params[:song] + @artist.name.to_s)[@youtube_index.to_i]['video_id']
      erb :video_picker
    end


    get '/artists' do
      @artists = Artist.all 
      erb :artists_library
    end

    get '/artists/:last_name' do
      @artist = Artist.find_by_last_name(params[:last_name]).first
      erb :artist
    end

    get '/songs/:song/confirm/:index' do
      @song = Song.find_by_name(params[:song]).first
      @artist_name = @song.artist.name
      @youtube_index = params[:index]
      @song.youtube_index = @youtube_index
      @id = YoutubeSearch.search(params[:song] + @artist_name.to_s)[@youtube_index.to_i]['video_id']
      erb :song
    end


    get '/songs/:song/:index' do
      @song = Song.find_by_name(params[:song]).first
      @artist_name = @song.artist.name
      @youtube_index = params[:index]
      @id = YoutubeSearch.search(params[:song] + @artist_name.to_s)[@youtube_index.to_i]['video_id']
      erb :song
    end

    get '/genres/:genre' do
      @genre = Genre.find_by_name(params[:genre]).first
      erb :genre
    end

    get '/genres' do
      @genres = Genre.all
      erb :genres_library
    end

    get '/songs' do
      @songs = Song.all
      erb :songs_library
    end
  end
end
