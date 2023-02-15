require "sinatra/base"
require "sinatra/reloader"

require "./lib/database_connection.rb"
require "./lib/space.rb"
require "./lib/space_repository.rb"
require "./lib/maker.rb"
require "./lib/maker_repository.rb"
require "./lib/user.rb"
require "./lib/user_repository.rb"

DatabaseConnection.connect("makersbnb_test")

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
    also_reload "lib/maker_repository"
    also_reload "lib/user_repositor"
  end

  get "/" do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
    end
    return erb(:index)
  end

  get "/makers/login" do
    return erb(:makers_login)
  end

  get "/makers/signup" do
    return erb(:makers_signup)
  end

  post "/makers/signup" do
    repo = MakersRepository.new
    name = params[:name]
    email = params[:email]
    password = params[:password]
    
    if name.nil? || email.nil? || password.nil? || name == "" || email == "" || password == ""
      return erb(:makers_signup)
    else
      new_maker = Makers.new
      new_maker.name = name
      new_maker.email = email
      new_maker.password = password
  
      repo.create(new_maker)
  
      return erb(:makers_login)
    end
  end
  # This route receives login information (email and password)
  # as body parameters, and find the user in the database
  # using the email. If the password matches, it returns
  # a success page.
  post "/makers/login" do
    repo = MakersRepository.new

    email = params[:email]
    password = params[:password]

    maker = repo.find_by_email(email)

    # This is a simplified way of
    # checking the password. In a real
    # project, you should encrypt the password
    # stored in the database.

    if repo.sign_in(email, password)
      # Set the user ID in session
      session[:maker_id] = maker.id
      redirect "/spaces"
    else
      redirect('/makers/login')
    end
  end

  get "/users/signup" do
    return erb(:users_signup)
  end

  post "/users/signup" do
    repo = UsersRepository.new
    name = params[:name]
    email = params[:email]
    password = params[:password]
    
    if name.nil? || email.nil? || password.nil? || name == "" || email == "" || password == ""
      return erb(:users_signup)
    else
      new_user = Users.new
      new_user.name = name
      new_user.email = email
      new_user.password = password
  
      repo.create(new_user)
  
      return erb(:users_login)
    end
  end

  get "/users/login" do
    return erb(:users_login)
  end

  post "/users/login" do
    repo = UsersRepository.new

    email = params[:email]
    password = params[:password]

    if email.nil? || password.nil? || email == "" || password == ""
      return erb(:users_login)
    else
      user = repo.find_by_email(email)
  
      if repo.sign_in(email, password)
        session[:user_id] = user.id
        redirect "/spaces"
      else
        return erb(:users_login)
      end
    end
  end

  get "/logout" do
    session[:maker_id] = nil
    session[:user_id] = nil
    redirect "/"
  end

  get '/spaces/create' do
    repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      return erb(:spaces_creation)
    else
      redirect '/makers/login'
    end
  end

  post '/spaces/create' do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      @maker = maker_repo.find(session[:maker_id])
      new_space = Space.new
      new_space.name = params[:name]
      new_space.location = params[:location]
      new_space.description = params[:description]
      new_space.price = params[:price]
      new_space.date = params[:date]
      new_space.available = params[:available]
      new_space.maker_id = params[:maker_id]

      space_repo.create(new_space)
      
    else
      redirect '/makers/login'
    end
  end

  get "/spaces" do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      @spaces = space_repo.all
      return erb(:spaces)
    else
      redirect '/makers/login'
    end
  end

  get "/spaces/:id" do
    repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      @space = repo.find_by_id(params[:id])
      return erb(:space_single)
    else
      redirect '/makers/login'
    end
  end

end
