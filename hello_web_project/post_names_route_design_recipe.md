# {GET} {/names} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._


# Request:
POST http://localhost:9292/sort-names

# With body parameters:
names=Joe,Alice,Zoe,Julia,Kieran

# Expected response (sorted list of names):
Alice,Joe,Julia,Kieran,Zoe



## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

the HTTP method: PUT
the path: /sort-names (http://localhost:9292/sort-names)
body parameters (passed in the request body): names (string)
                                              names=Joe,Alice,Zoe,Julia,Kieran




## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._


When body params = Joe,Alice,Zoe,Julia,Kieran
```
Alice,Joe,Julia,Kieran,Zoe
```

When query params = James,Lewis,Andy
```
Andy, James, Lewis
```




```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

<html>
  <head></head>
  <body>
    <h1>Post title</h1>
    <div>Post content</div>
  </body>
</html>
```




## 3. Write Examples

_Replace these with your own design._

```
# Request:

GET /sort-names?names=Joe,Alice,Zoe,Julia,Kieran

# Expected response:

Response for 200 OK
```
Alice,Joe,Julia,Kieran,Zoe
```


# Request:

GET /names?names=James,Lewis,Andy

# Expected response:

Response for 200 OK
```
Andy, James, Lewis
```


# Request:

GET /namesss?names=Test,One,Two

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
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.