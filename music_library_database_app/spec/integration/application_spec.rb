require "spec_helper"
require "rack/test"
require_relative '../../app'


def reset_tables
  albums_seeds_sql = File.read('spec/seeds/albums_seeds.sql')
  artists_seeds_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(albums_seeds_sql)
  connection.exec(artists_seeds_sql)
end

describe Application do
  before(:each) do 
    reset_tables
  end
  
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'POST /albums' do
    it 'returns 200 OK and adds album to database' do
      response = post('/albums?title=Voyage&release_year=2022&artist_id=2')

      expect(response.status).to eq(200)
      # expect(response.body).to eq('')

      repo = AlbumRepository.new
      albums = repo.all
      
      expect(albums.last.id).to eq 13
      expect(albums.last.title).to eq 'Voyage'
      expect(albums.last.release_year).to eq '2022'
      expect(albums.last.artist_id).to eq 2
    end

    it 'returns 200 OK and adds album to database' do
      response = post('/albums?title=Indie%20Cindy&release_year=2014&artist_id=1')

      expect(response.status).to eq(200)
      # expect(response.body).to eq('')

      repo = AlbumRepository.new
      albums = repo.all
      
      expect(albums.last.id).to eq 13
      expect(albums.last.title).to eq 'Indie Cindy'
      expect(albums.last.release_year).to eq '2014'
      expect(albums.last.artist_id).to eq 1
    end

    it 'returns 404 Not Found' do
      response = post('/albumsss')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end

  context 'GET /artists' do
    it 'returns 200 OK and a list of artists' do
      response = get('/artists')

      expect(response.status).to eq(200)
      # expect(response.body).to eq('')

      repo = ArtistRepository.new
      artists = repo.all
      
      expect(artists.length).to eq 4
      expect(artists.first.id).to eq 1
      expect(artists.last.id).to eq 4
      expect(artists.first.name).to eq 'Pixies'
      expect(artists.last.name).to eq 'Nina Simone'
      expect(artists.first.genre).to eq 'Rock'
      expect(artists.last.genre).to eq 'Pop'    
    end

    it 'returns 404 Not Found' do
      response = get('/artistsss')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end
end