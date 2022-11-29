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
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]
    
    sql = "INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3)"
    params = [title, release_year, artist_id]

    DatabaseConnection.exec_params(sql, params)
    return nil
  end
end