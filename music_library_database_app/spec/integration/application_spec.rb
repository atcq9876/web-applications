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

  context 'GET /albums/new' do
    it 'returns a page with a form to add an album' do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add an album</h1>')
      expect(response.body).to include('<form action="/albums" method="POST">')
      expect(response.body).to include('<label>Album title: </label>')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<label>Release year: </label>')
      expect(response.body).to include('<input type="number" name="release_year" />')
      expect(response.body).to include('<label>Artist ID: </label>')
      expect(response.body).to include('<input type="number" name="artist_id" />')
      expect(response.body).to include('<input type="submit" />')
    end
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
    it 'adds new album to database and returns success message' do
      response = post('/albums',
      title: 'Trompe le Monde',
      release_year: '1991',
      artist_id: '1')

      expect(response.status).to eq(200)
      expect(response.body).to eq('<h2>You added the album: Trompe le Monde!</h2>')

      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/13">Trompe le Monde</a>')
    end

    it 'adds a different album to database and returns success message' do
      response = post('/albums',
      title: 'Indie Cindy',
      release_year: '2014',
      artist_id: '1')

      expect(response.status).to eq(200)
      expect(response.body).to eq('<h2>You added the album: Indie Cindy!</h2>')

      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/13">Indie Cindy</a>')
    end

    it 'returns an error message when a field is not filled' do
      response = post('/albums',
      title: 'Trompe le Monde',
      release_year: '1991',
      artist_id: '')

      expect(response.status).to eq(400)
      expect(response.body).to eq('Please fill in all fields')    
    end

    it 'returns an error message when a field is not filled' do
      response = post('/albums',
      release_year: '1991',
      artist_id: '1')

      expect(response.status).to eq(400)
      expect(response.body).to eq('Please fill in all fields')    
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

  context "GET /artists/new" do
    it "returns a form to add a new artist" do
      response = get('artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add an artist</h1>')
      expect(response.body).to include('<form action="/artists" method="POST">')
      expect(response.body).to include('<label>Artist name: </label>')
      expect(response.body).to include('<input type="text" name="name" /><br>')
      expect(response.body).to include('<label>Genre: </label')
      expect(response.body).to include('<input type="text" name="genre" /><br>')
      expect(response.body).to include('<input type="submit" />')
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
      expect(response.body).to eq('<h2>You added the artist: Wild Nothing!</h2>')

      response = get('/artists')
      expect(response.body).to include('Wild Nothing')
    end

    it 'returns 200 OK and adds other artist to database' do
      response = post(
        '/artists',
        name: 'Test',
        genre: 'Electronic')

      expect(response.status).to eq(200)
      expect(response.body).to eq('<h2>You added the artist: Test!</h2>')

      response = get('/artists')
      expect(response.body).to include('Test')
    end

    it 'returns 400 if invalid parameters' do
      response = post(
        '/artists',
        name: '',
        genre: 'Electronic')

      expect(response.status).to eq(400)
      expect(response.body).to eq('Please fill in all fields!')
    end

    it 'returns 400 if invalid parameters' do
      response = post(
        '/artists',
        name: 'Band',)

      expect(response.status).to eq(400)
      expect(response.body).to eq('Please fill in all fields!')
    end

    it 'returns 404 Not Found' do
      response = post('/artistsss')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end
end