require "spec_helper"
require "rack/test"
require_relative "../../app"
require "json"

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.

  context "GET /" do
    it "should get the homepage" do
      response = get("/")

      expect(response.status).to eq(200)
    end
  end

  context "GET /makers/login" do
    it "should get the Makers Login page" do
      response = get("/makers/login")

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Makers Login</h1>")
      expect(response.body).to include('<form action="/makers/login" method="POST">')
      expect(response.body).to include('input type="email" class="form-control" name="email"')
      expect(response.body).to include('input type="password" class="form-control" name="password"')
    end
  end

  context "GET /makers/signup" do
    it "should get the Sign up page" do
      response = get("/makers/signup")

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Makers Sign Up</h1>")
      expect(response.body).to include('<form action="/makers/signup" method="POST">')
      expect(response.body).to include('<input type="name" class="form-control" name="name">')
      expect(response.body).to include('<input type="email" class="form-control" name="email">')
      expect(response.body).to include('<input type="password" class="form-control" name="password">')
    end
  end

  context "POST /makers/login" do
    it "should log the user in and redirect to /spaces if correct credentials are given" do
      post "/makers/login",
           { email: "black_jack@email.com",
             password: "giant" }
      follow_redirect!

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("<h1>Spaces</h1>")
    end

    it "should redirect to makers/login if empty inputs are given" do
      post "/makers/login",
           { email: "",
             password: "" }
      # follow_redirect!

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("<h1>Makers Login</h1>")
    end

    it "should redirect to makers/login if wrong inputs are given" do
      post "/makers/login",
           { email: "no_one@gmail.com",
             password: "password" }
      follow_redirect!

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("<h1>Makers Login</h1>")
    end
  end

  context "POST /makers/signup" do
    it "should get the signup page" do
      response = post(
        "/makers/signup",
        name: "Jack Daniels",
        email: "jack@email.com",
        password: "giantqwe",
      )

      expect(response.status).to eq(200)
    end

    it "should go back to signup page when empty inputs are given" do
      response = post(
        "/makers/signup",
        name: "",
        email: "",
        password: "",
      )
      expect(response.body).to include("<h1>Makers Sign Up</h1>")
      expect(response.status).to eq(200)
    end

    it "should go back to signup page if no inputs are given" do
      response = post("/makers/signup")

      expect(response.body).to include("<h1>Makers Sign Up</h1>")
      expect(response.status).to eq(200)
    end
  end

  context "GET /users/signup" do
    it "should get the signup page for users" do
      response = get("/users/signup")

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Users Sign Up</h1>")
      expect(response.body).to include('<form action="/users/signup" method="POST">')
      expect(response.body).to include('<input type="name" class="form-control" name="name">')
      expect(response.body).to include('<label for="exampleInputEmail1" class="form-label">Email address</label>')
      expect(response.body).to include('<input type="password" class="form-control" name="password">')
    end

    it "should go back to signup page when empty inputs are given" do
      response = post(
        "/users/signup",
        name: "",
        email: "",
        password: "",
      )
      expect(response.body).to include("<h1>Users Sign Up</h1>")
      expect(response.status).to eq(200)
    end

    it "should go back to signup page if no inputs are given" do
      response = post("/users/signup")

      expect(response.body).to include("<h1>Users Sign Up</h1>")
      expect(response.status).to eq(200)
    end
  end

  context "POST /users/signup" do
    it "should get the signup page for users" do
      response = post(
        "users/signup",
        name: "David Beckham",
        email: "david@email.com",
        password: "football",
      )

      expect(response.status).to eq(200)
    end
  end

  context "GET /users/login" do
    it "should get the Users Login page" do
      response = get("/users/login")

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>User Login</h1>")
      expect(response.body).to include('<form action="/users/login" method="POST">')
      expect(response.body).to include('input type="email" class="form-control" name="email"')
      expect(response.body).to include('input type="password" class="form-control" name="password"')
    end
  end

  context "POST /users/login" do
    it "should log the user in" do
      response = post(
        "/users/login",
        email: "pikachu@pokemon.com",
        password: "pikipi",
      )

      expect(response.status).to eq(302)
    end

    it "should return to user login page if the inputs is empty" do
      response = post(
        "/users/login",
        email: "",
        password: "",
      )
      expect(response.body).to include("<h1>User Login</h1>")
      expect(response.status).to eq(200)
    end

    it "should should return to user login page if the inputs is nil" do
      response = post(
        "/users/login"
      )

      expect(response.body).to include("<h1>User Login</h1>")
      expect(response.status).to eq(200)
    end
  end

  # GET /spaces
  context "GET /spaces" do
    it "should return all the spaces after logging in as a maker" do
      get "/spaces", {}, { "rack.session" => { maker_id: 1 } }

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("<h1>Spaces</h1>")
    end

    it "should redirect to login page with a message without logging in" do
      get "/spaces"
      follow_redirect!

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("<h1>User Login</h1>")
    end
  end
  # GET /spaces/create
  context "GET /spaces/create" do
    it "should get the page to add a new space" do
      response = get("/spaces/create")

      expect(response.status).to eq(302)
    end
  end

  # PUT /spaces
  # xcontext "PATCH /spaces" do
  #   it "should update a space" do
  #     response = patch("/spaces")

  #     expect(response.status).to eq(200)
  #   end
  # end

  # GET /spaces/:id
  context "GET /spaces/:id" do
    it "should return a space with a given id after logging in" do
      get "/spaces/1", {}, { "rack.session" => { maker_id: 1 } }

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("London")
    end

    it "should redirect to login page with a message without logging in" do
      get "/spaces/1"
      follow_redirect!

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("<h1>User Login</h1>")
    end
  end

  # GET /spaces/:maker_id
  # xcontext "GET /spaces/:maker_id" do
  #   it "should return a list of spaces with a given maker id" do
  #     response = get("/spaces/2")

  #     expect(response.status).to eq(200)
  #     expect(response.body).to include("<p>Location: Leeds</p>")
  #     expect(response.body).to include("<p>Name: Space B</p>")
  #     expect(response.body).to include("<p>Name: Space C</p>")
  #   end
  # end

  # # GET /spaces/:date
  # xcontext "GET /spaces/:date" do
  #   it "should return a list of spaces with a given date" do
  #     response = get("/spaces/2022-02-14")

  #     expect(response.status).to eq(200)
  #     expect(response.body).to include("<p>Location: Leeds</p>")
  #     expect(response.body).to include("<p>Name: Space B</p>")
  #     expect(response.body).to include("<p>Name: Space C</p>")
  #   end
  # end

  # # GET /spaces/:location
  # xcontext "GET /spaces/:location" do
  #   it "should return a list of spaces with a given location" do
  #     response = get("/spaces/leeds")

  #     expect(response.status).to eq(200)
  #     expect(response.body).to include("<p>Location: Leeds</p>")
  #     expect(response.body).to include("<p>Name: Space B</p>")
  #     expect(response.body).to include("<p>Name: Space C</p>")
  #   end
  # end

  context "GET /bookings/:id" do
    it "allows a user to book a space and returns a booking confirmation" do
      get "/bookings/1", {}, { "rack.session" => { user_id: 1 } }

      expect(last_response.status).to eq 200
      expect(last_response.body).to include("Booking Details")
    end
  end

  context "POST /bookings/:id" do
    it "creates a booking request" do
      post '/bookings/1',{ confirmed: false, requested_space_id: 1, requested_user_id: 1 }, { "rack.session" => { user_id: 1 } }
      follow_redirect!
      expect(last_response.status).to eq(200)
    end
  end
end
