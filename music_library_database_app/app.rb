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

  get '/albums' do
    album_repo = AlbumRepository.new
    @albums = album_repo.all

    return erb(:albums)
  end

  get '/albums/new' do
    return erb(:album_new)
  end

  get '/albums/:id' do
    id = params[:id]

    album_repo = AlbumRepository.new
    @album = album_repo.find(id)

    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end

  post '/albums' do
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]

    if title == nil || title == '' || release_year == nil || release_year == '' || artist_id == nil || artist_id == ''
      status 400
      return 'Please fill in all fields'
    else
      @album = Album.new
      @album.title = title
      @album.release_year = release_year
      @album.artist_id = artist_id
      
      album_repo = AlbumRepository.new
      album_repo.create(@album)
      
      return erb(:album_added)
    end
  end

  get '/artists' do
    artist_repo = ArtistRepository.new
    @artists = artist_repo.all

    return erb(:artists)
  end

  get '/artists/new' do
    return erb(:artist_new)
  end

  get '/artists/:id' do
    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(params[:id])

    return erb(:artist)
  end

  post '/artists' do
    name = params[:name]
    genre = params[:genre]

    if name == nil || name == '' || genre == nil || genre == ''
      status 400
      return 'Please fill in all fields!'
    else
      @artist = Artist.new
      @artist.name = name
      @artist.genre = genre
      
      artist_repo = ArtistRepository.new
      artist_repo.create(@artist)

      return erb(:artist_added)
    end
  end
end