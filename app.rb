require "sinatra/base"
require "sinatra/reloader"
require "rack-flash"
require 'date'

require "./lib/database_connection.rb"
require "./lib/space.rb"
require "./lib/space_repository.rb"
require "./lib/maker.rb"
require "./lib/maker_repository.rb"
require "./lib/user.rb"
require "./lib/user_repository.rb"
require "./lib/booking.rb"
require "./lib/booking_repository.rb"

DatabaseConnection.connect("makersbnb_test")

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
    also_reload "lib/maker_repository"
    also_reload "lib/user_repository"
    use Rack::Flash
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
      flash.now[:message] = "Empty inputs are not acceptable. Please enter again."
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

    if email.nil? || password.nil? || email == "" || password == ""
      flash.now[:message] = "Empty inputs are not acceptable. Please enter again."
      return erb(:makers_login)
    else
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
        redirect "/makers/login"
      end
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
      flash.now[:message] = "Empty inputs are not acceptable. Please enter again."
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
      flash.now[:message] = "Empty inputs are not acceptable. Please enter again."
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

  get "/spaces/create" do
    repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      return erb(:spaces_creation)
    else
      redirect "/makers/login"
    end
  end

  post "/spaces/create" do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if name.nil? || location.nil? || price.nil? || description.nil? || date.nil? || name == "" || location == "" || price == "" || description == "" || date == ""
      flash.now[:message] = "Empty inputs are not acceptable. Please enter again."
      return erb(:makers_signup)
    end
    
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      new_space = Space.new
      new_space.name = params[:name]
      new_space.location = params[:location]
      new_space.description = params[:description]
      new_space.price = params[:price]
      new_space.date = params[:date]
      new_space.available = true
      new_space.maker_id = @maker.id

      space_repo.create(new_space)
      
      redirect('/spaces')
    else
      redirect "/makers/login"
    end
  end

  get "/spaces" do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      @spaces = space_repo.all
      # image_links = ["https://tinyurl.com/33a8ej3w", "https://tinyurl.com/2sf43hmc", "https://tinyurl.com/4f6ftbmx", "https://tinyurl.com/2yuzk6bs", "https://tinyurl.com/4xtw833j", "https://tinyurl.com/32pd2as4", "https://tinyurl.com/4hnspe4t", "https://tinyurl.com/43z3r7hh", "https://tinyurl.com/yt7ubuh3", "https://tinyurl.com/4hv6j2fb"]

      # @photos = image_links.sample
      return erb(:spaces)
    else
      redirect "/makers/login"
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
      redirect "/makers/login"
    end
  end

  get "/bookings" do
    maker_repo = MakersRepository.new
    space_repo = SpaceRepository.new
    if session[:maker_id]
      flash[:message] = "You are not allowed to make a booking as a maker."
      redirect "/spaces"
    elsif session[:user_id]
      @user = user_repo.find(session[:user_id])
      # pass a list of spaces 
      @spaces = space_repo.all
      return erb :bookings
    else
      flash[:message] = "You have to log in before making a booking."
      redirect "/users/login"
    end
  end

  post "/bookings" do
    space_repo = SpaceRepository.new
    # get inputs from the user
    date = params[:date]
    space_id = params[:space_id]
    # get the user_id from session
    user_id = session[:user_id]
    # fetch data from space database and find a space based on id
    selected_space = space_repo.find(space_id)
    #  check the availability
    #   - if okay: redirect to /spaces with a successful message
    #   - not okay: redirect to /bookings with a error message
  end
end
