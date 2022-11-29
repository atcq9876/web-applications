require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /names" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/names?names=Julia,Mary,Karim')

      expect(response.status).to eq(200)
      expect(response.body).to eq("Julia, Mary, Karim")
    end

    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/names?names=Andy,James,Lewis')

      expect(response.status).to eq(200)
      expect(response.body).to eq("Andy, James, Lewis")
    end

    it 'returns 404 Not Found' do
      response = get('/posts?id=276278')

      expect(response.status).to eq(404)
    end
  end

  context 'POST /sort-names' do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/sort-names?names=Joe,Alice,Zoe,Julia,Kieran')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Alice, Joe, Julia, Kieran, Zoe')
    end

    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/sort-names?names=James,Lewis,Andy')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Andy, James, Lewis')
    end

    it 'returns 404 Not Found' do
      response = post('/namesss?names=Test,One,Two')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end

  context 'GET /hello' do
    it "returns 'Hello!' as an html heading" do
      response = get('/hello')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Hello!</h1>')
    end
  end
end