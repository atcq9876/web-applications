require 'sinatra/base'
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/hello' do
    name = params[:name]
    
    # /\d/ == /[0-9]/   /\W/ == anything that isn't 0-9, a-z or A-Z
    if name.match(/\d/) || name.match(/\W/)
      return 'Invalid name'
    else
      @name = params[:name]
      return erb(:hello)
    end
  end
end