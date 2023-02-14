require 'sinatra/base'
require 'sinatra/reloader'
require './lib/database_connection.rb'
require './lib/space.rb'
require './lib/space_repository.rb'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  get '/spaces' do
    repo = SpaceRepository.new
    @spaces = repo.all
    return erb(:spaces)
  end

  get '/spaces/:id' do
    repo = SpaceRepository.new
    @space = repo.find_by_id(params[:id])
    return erb(:space_single)
  end

end