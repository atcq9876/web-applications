require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /" do
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
end