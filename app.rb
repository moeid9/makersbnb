require "sinatra/base"
require "sinatra/reloader"
require "rack-flash"
require "date"

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
    user_repo = UsersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
    else session[:user_id]
      @user = user_repo.find(session[:user_id])     end
    return erb(:index)
  end

  get "/makers/login" do
    session[:user_id] = nil
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
    session[:maker_id] = nil
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
    # Generate random inputs
    @name = ["The Point Cottage, Loch Striven", "Llanelli Beach Sea View apartment", "Sea Thrift Beach House Tywyn", "Surfsplash beachfront Holiday Cottage, Dunbar"].sample
    @location = ["London", "Manchester", "Bristol", "Cardiff", "Edinburgh"].sample
    @description = ["Sea Thrift Beach House offers guests spacious and contemporary coastal living from an enviable beach front location, with panoramic sea views stretching across Cardigan Bay.", "The Point is a beautifully appointed remote holiday cottage on the banks of Loch Striven, Argyll, Scotland. The master bedroom features a sitting area and a balcony .The second bedroom has a double bed, robe, chest of drawers.", "First floor modern apartment situated on Carmarthenshire Coastal Path. 25 meters off Llanelli beach. The apartment offers  breath taking sea views  of Llanelli beach, Loughor estuary and across to the Gower peninsula."].sample
    @date = ["2023-02-17", "2023-4-7", "2023-3-13"].sample

    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      return erb(:spaces_creation)
    else
      flash.now[:message] = "You have to log in to create a space."
      redirect "/makers/login"
    end
  end

  post "/spaces/create" do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new

    name = params[:name]
    location = params[:location]
    price = params[:price]
    description = params[:description]
    date = params[:date]

    if name.nil? || location.nil? || price.nil? || description.nil? || date.nil? || name == "" || location == "" || price == "" || description == "" || date == ""
      flash[:message] = "Empty inputs are not acceptable. Please enter again."
      redirect "/spaces/create"
    end

    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      new_space = Space.new
      new_space.name = name
      new_space.location = location
      new_space.description = description
      new_space.price = price
      new_space.date = date
      new_space.available = true
      new_space.maker_id = session[:maker_id]

      space_repo.create(new_space)

      redirect("/spaces")
    else
      flash.now[:message] = "You have to log in to create a space."
      redirect "/makers/login"
    end
  end

  get "/spaces" do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    user_repo = UsersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      @spaces = space_repo.all
      # image_links = ["https://tinyurl.com/33a8ej3w", "https://tinyurl.com/2sf43hmc", "https://tinyurl.com/4f6ftbmx", "https://tinyurl.com/2yuzk6bs", "https://tinyurl.com/4xtw833j", "https://tinyurl.com/32pd2as4", "https://tinyurl.com/4hnspe4t", "https://tinyurl.com/43z3r7hh", "https://tinyurl.com/yt7ubuh3", "https://tinyurl.com/4hv6j2fb"]

      # @photos = image_links.sample
      return erb(:spaces)
    elsif session[:user_id]
      @user = user_repo.find(session[:user_id])
      @spaces = space_repo.all
      # image_links = ["https://tinyurl.com/33a8ej3w", "https://tinyurl.com/2sf43hmc", "https://tinyurl.com/4f6ftbmx", "https://tinyurl.com/2yuzk6bs", "https://tinyurl.com/4xtw833j", "https://tinyurl.com/32pd2as4", "https://tinyurl.com/4hnspe4t", "https://tinyurl.com/43z3r7hh", "https://tinyurl.com/yt7ubuh3", "https://tinyurl.com/4hv6j2fb"]

      # @photos = image_links.sample
      return erb(:spaces)
    else
      flash[:message] = "You have to log in to browse spaces."
      redirect "/users/login"
    end
  end

  get "/spaces/:id" do
    repo = SpaceRepository.new
    user_repo = UsersRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
      @space = repo.find_by_id(params[:id])
      return erb(:space_single)
    elsif session[:user_id]
      @user = user_repo.find(session[:user_id])
      @space = repo.find_by_id(params[:id])
      return erb(:space_single)
    else
      redirect "/"
    end
  end

  get "/bookings/:space_id" do
    if session[:user_id]
      space_repo = SpaceRepository.new
      @space = space_repo.find_by_id(params[:space_id])
      return erb(:booking_confirmation)
    else
      flash[:message] = "You have to log in as a user to make a booking."
      redirect "/users/login"
    end
  end

  post "/bookings/:space_id" do
    booking_repo = BookingRepository.new
    new_booking = Bookings.new
    new_booking.confirmed = false
    new_booking.requested_space_id = params[:space_id]
    new_booking.requested_user_id = session[:user_id]
    booking_repo.create(new_booking)
    flash[:message] = "Your booking has been submitted! Maker will confirm it soon."
    redirect "/spaces"
  end

  get "/makers/confirmation" do
    # if user has maker_id
    if session[:maker_id]
      maker_repo = MakersRepository.new
      booking_repo = BookingRepository.new
      @maker = maker_repo.find(session[:maker_id])
      @bookings = booking_repo.find_by_maker_id(session[:maker_id])
      return erb(:maker_confirmation)
    else
      flash[:message] = "You have to log in as a maker to confirm bookings."
      redirect "/makers/login"
    end
  end

  get "/makers/confirm_request/:space_id" do
    book_repo = BookingRepository.new
    space_repo = SpaceRepository.new
    @booking = book_repo.find_by_space_id(params[:space_id])
    book_repo.delete(@booking.id)
    space_repo.delete(params[:space_id])
    flash[:message] = "You have confirmed a booking."
    redirect "/makers/confirmation"
  end

  get "/makers/my-spaces" do
    if session[:maker_id]
      maker_repo = MakersRepository.new
      spaces_repo = SpaceRepository.new
      @maker = maker_repo.find(session[:maker_id])
      @spaces = spaces_repo.find_by_maker(session[:maker_id])
      return erb(:my_spaces)
    else
      flash[:message] = "You have to log in as a maker to view your spaces."
      redirect "/makers/login"
    end
  end

  get "/spaces/delete/:space_id" do
    space_repo = SpaceRepository.new
    maker_id = session[:maker_id].to_i
    if maker_id
      space = space_repo.find_by_id(params[:space_id])
      if space.maker_id == maker_id
        space_repo.delete(params[:space_id])
        flash[:message] = "You have deleted '#{space.name}'."
        redirect "/spaces"
      else
        flash[:message] = "You are not authorised to do so."
        redirect "/spaces"
      end
    else
      flash[:message] = "You have to log in as a maker to delete your spaces."
      redirect "/makers/login"
    end
  end
end
