# {GET} {/names} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._


# Request:
GET /artists (http://localhost:9292/artists)

# With body parameters:
N/A

# Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone



## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

the HTTP method: GET
the path: /artists (http://localhost:9292/artists)





## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._


GET /artists
With no query params
```
status = 200 OK

Pixies, ABBA, Taylor Swift, Nina Simone
```



```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

<!-- <html>
  <head></head>
  <body>
    <h1>Post name</h1>
    <div>Post content</div>
  </body>
</html> -->
```




## 3. Write Examples

_Replace these with your own design._


# Request:

GET /artists

# Expected response:

Response for 200 OK
```
Pixies, ABBA, Taylor Swift, Nina Simone
```


# Request:

GET /artistsss

# Expected response:

```
Response for 404 Not Found
```



## 4. Encode as Tests Examples

```ruby
# file: spec/integration/application_spec.rb

require 'spec_helper'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context 'GET /artists' do
    it 'returns 200 OK and a list of artists' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone')
    end

    it 'returns 404 Not Found' do
      response = get('/artistsss')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.