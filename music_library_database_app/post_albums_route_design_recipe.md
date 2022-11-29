# {GET} {/names} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._


# Request:
POST /albums (http://localhost:9292/albums)

# With body parameters:
title=Voyage
release_year=2022
artist_id=2

# Expected response (sorted list of names):
(No content)



## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

the HTTP method: POST
the path: /albums (http://localhost:9292/albums)
body parameters (passed in the request body): title (string)
                                              release_year (int)
                                              artist_id (int)




## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._


When body params = title=Voyage&release_year=2022&artist_id=2
```
status = 200 OK

(No content)
```



```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

<!-- <html>
  <head></head>
  <body>
    <h1>Post title</h1>
    <div>Post content</div>
  </body>
</html> -->
```




## 3. Write Examples

_Replace these with your own design._

```
# Request:

POST /albums
title=Voyage
release_year=2022
artist_id=2

# Expected response:

Response for 200 OK
```
(No content)
```


# Request:

POST /albums
title=Indie Cindy
release_year=2014
artist_id=1

# Expected response:

Response for 200 OK
```
(No content)
```

# Request:

POST /albumssss

title=Voyage
release_year=2022
artist_id=2

# Expected response:

Response for 404 Not Found
```



## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require 'spec_helper'

describe Application do
  include Rack::Test::Methods

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
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.