# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  post '/albums' do
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    
    album_repo = AlbumRepository.new
    album_repo.create(album)

    return ''
  end

  get '/artists' do
    artist_repo = ArtistRepository.new
    artists = artist_repo.all
    artist_names = []
    artists.map do |artist|
      artist_names << artist.name
    end
    return artist_names.join(', ')
  end

  post '/artists' do
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    
    artist_repo = ArtistRepository.new
    artist_repo.create(artist)

    return ''
  end
end