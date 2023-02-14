require 'sinatra/base'
require 'sinatra/reloader'

require './lib/database_connection.rb'
require './lib/space.rb'
require './lib/space_repository.rb'
require './lib/maker.rb'
require './lib/maker_repository.rb'
require './lib/user.rb'
require './lib/user_repository.rb'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/maker_repository'
    also_reload 'lib/user_repositor'
    
  end

  get '/' do
    return erb(:index)
  end


  get '/makers/login' do
    return erb(:makers_login)
  end

  get '/makers/signup' do
    return erb(:makers_signup)
  end

  post '/makers/signup' do
    repo = MakersRepository.new
    new_maker = Makers.new
    new_maker.name = params[:name]
    new_maker.email = params[:email]
    new_maker.password = params[:password]

    repo.create(new_maker)

    return erb(:makers_login)
  end
  # This route receives login information (email and password)
  # as body parameters, and find the user in the database
  # using the email. If the password matches, it returns
  # a success page.
  post '/makers/login' do
    repo = MakersRepository.new
    
    email = params[:email]
    password = params[:password]

    maker = repo.find_by_email(email)
    
    # This is a simplified way of 
    # checking the password. In a real 
    # project, you should encrypt the password
    # stored in the database.
    if maker.password == password
      # Set the user ID in session
      session[:maker_id] = maker.id

      return erb(:login_success)
    else
      return''
    end
  end

  get '/users/signup' do
    repo = UsersRepository.new
    new_users = Users.new
    new_users.name = params[:name]
    new_users.email = params[:email]
    new_users.password = params[:password]

    repo.create(new_users)

    return erb(:users_signup)
  end
  
  post '/users/signup' do
    repo = UsersRepository.new
    new_user = Users.new
    new_user.name = params[:name]
    new_user.email = params[:email]
    new_user.password = params[:password]

    repo.create(new_user)

    return erb(:users_login)
  end

  get '/users/login' do
    return erb(:users_login)
  end

  post '/users/login' do
    repo = UsersRepository.new
    
    email = params[:email]
    password = params[:password]

    user = repo.find_by_email(email)

    p user

    if user.password == password
      session[:user] = user.id
      return erb(:index)
    else
      return ''
    end
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