require 'sinatra/base'
require_relative 'models/parser'
require 'youtube_it'

module PlaylisterSite
  class App < Sinatra::Base
    def self.parse
      if Artist.all != []
        Artist.reset_artists
        Genre.reset_genres
        Song.reset_songs
      end
        Parse.new.parse
    end
    parse

    get '/form/add' do
      erb :add_song
    end

    post '/form/add' do
      @song_name = params[:song_name]
      @artist_name = params[:artist_name]
      @genre_name = params[:genre_name]
      
      @song = Song.new
      @song.name = @song_name

      @genre = Genre.all.select{|genre| genre.name == @genre_name}.first
      if @genre
          @song.genre = @genre
      else
          @genre = Genre.new
          @genre.name = @genre_name
          @song.genre = @genre
      end

      @artist = Artist.new
      @artist.name = @artist_name
      @artist.add_song(@song)

      @artists = Artist.all
      # debugger
      erb :index_template
    end

    get '/' do
      @artists = Artist.all 
      erb :index_template
    end

    get '/artists/:last_name' do
      # debugger
      @artist = Artist.find_by_last_name(params[:last_name]).first
      erb :artist_template
    end

    get '/songs/:song' do
      @song = Song.find_by_name(params[:song]).first
      client = YouTubeIt::Client.new
      @video_html = client.videos_by(:query => params[:song]).videos[0].embed_html_with_width 
      erb :song_template
    end

    get '/genres/:genre' do
      @genre = Genre.find_by_name(params[:genre]).first
      erb :genre_template
    end
  end
end
