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


  context 'GET /albums' do
    it 'returns a list of albums with links to their respective pages' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/1">Doolittle</a>')
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a>')
    end
  end

  it 'returns 404 Not Found' do
    response = get('/albumsss')

    expect(response.status).to eq(404)
    # expect(response.body).to eq(expected_response)
  end

  context 'GET /albums/:id' do
    it 'returns the albums with the given id' do
      response = get('/albums/1')
      
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end

    it 'returns the albums with the given id' do
      response = get('/albums/2')
      
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end

    it 'returns 404 Not Found' do
      response = get('/albumsss/1')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end

  context 'POST /albums' do
    it 'returns 200 OK and adds album to database' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: '2022',
        artist_id: '2')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      repo = AlbumRepository.new
      albums = repo.all
      
      expect(albums.last.id).to eq 13
      expect(albums.last.title).to eq 'Voyage'
      expect(albums.last.release_year).to eq '2022'
      expect(albums.last.artist_id).to eq 2
    end

    it 'returns 200 OK and adds album to database' do
      response = post(
        '/albums',
        title: 'Indie Cindy',
        release_year: '2014',
        artist_id: '1')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

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


  context "GET /artists" do
    it "returns a list of artists with links to their respective pages" do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="artists/1">Pixies</a>')
      expect(response.body).to include('<a href="artists/2">ABBA</a>')
      expect(response.body).to include('<a href="artists/3">Taylor Swift</a>')
    end

    it 'returns 404 Not Found' do
      response = get('/artistsss')
  
      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end

  context "GET /artists/:id" do
    it "returns info for the artist with the given id" do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
    end

    it "returns info for the artist with the given id" do
      response = get('/artists/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Genre: Pop')
    end

    it "returns 404 Not Found" do
      response = get('/artistss/1')
  
      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end

  context 'POST /artists' do
    it 'returns 200 OK and adds artist to database' do
      response = post(
        '/artists',
        name: 'Wild Nothing',
        genre: 'Indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Wild Nothing')
    end

    it 'returns 200 OK and adds artist to database' do
      response = post(
        '/artists',
        name: 'Test',
        genre: 'Electronic')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Test')
    end

    it 'returns 404 Not Found' do
      response = post('/artistsss')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end
end