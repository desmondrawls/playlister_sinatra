require 'sinatra/base'
require_relative 'models/parser'
require 'youtube_it'


module PlaylisterSite
  class App < Sinatra::Base
    before do
      Artist.reset_artists
      Genre.reset_genres
      Song.reset_songs
      Parse.new.parse
    end

    get '/form/add' do
      erb :add_song
    end

    post '/form/add' do
      @song_name = params[:song_name]
      @artist_name = params[:artist_name]
      @genre_name = params[:genre_name]
    end

    get '/' do
      @artists = Artist.all 
      erb :index_template
    end

    get '/artists/:last_name' do
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
