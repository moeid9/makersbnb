require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

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


  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
    end
  end


  context 'GET /login' do
    it 'should get the Login page' do
      response = get('/login')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Login</h1>')
      expect(response.body).to include('<form action="/login" method="POST">')
      expect(response.body).to include('<input type = "text" name = "email" />')
      expect(response.body).to include('<input type = "text" name = "password" />')
    end
  end

  context 'GET /signup' do
    it 'should get the Sign up page' do
      response = get('/signup')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Sign Up</h1>')
      expect(response.body).to include('<form action="/signup" method="POST">')
      expect(response.body).to include('<input type = "text" name = "name" />')
      expect(response.body).to include('<input type = "text" name = "email" />')
      expect(response.body).to include('<input type = "text" name = "password" />')
    end
  end

  context 'POST /login' do
    it 'should get the Login page' do
      response = post(
        '/login',
        email: 'black_jack@email.com',
        password: 'giant'
      )

      expect(response.status).to eq(200)

    end
  end

  context 'POST /signup' do
    it 'should get the signup page' do
      response = post(
        '/signup',
        name: 'Jack Daniels',
        email: 'jack@email.com',
        password: 'giantqwe'
      )

      expect(response.status).to eq(200)
=======
  # GET /spaces 
  context 'GET /spaces' do
    it 'should return all the spaces' do
      response = get('/spaces')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Book a Space</h1>')
    end
  end
  # GET /spaces/create 
  xcontext 'GET /spaces/create' do
    it 'should get the page to add a new space' do
      response = get('/spaces')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add a new space</h1>')
    end
  end
  # POST /spaces
  xcontext 'POST /spaces' do
    it 'should add a new space' do
      response = post('/spaces')

      expect(response.status).to eq(200)
    end
  end
  # DELETE /spaces
  xcontext 'POST /spaces' do
    it 'should add a new space' do
      response = delete('/spaces')

      expect(response.status).to eq(200)

      repo = SpaceRepository.new
      
      expect(repo.all.length).to eq 4
    end
  end
  # PUT /spaces
  xcontext 'PATCH /spaces' do
    it 'should update a space' do
      response = patch('/spaces')

      expect(response.status).to eq(200)
    end
  end

  # GET /spaces/:id
  context 'GET /spaces/:id' do
    it 'should return a space with a given id' do
      response = get('/spaces/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Location: London</p>')
    end
  end

  # GET /spaces/:maker_id
  xcontext 'GET /spaces/:maker_id' do
    it 'should return a list of spaces with a given maker id' do
      response = get('/spaces/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Location: Leeds</p>')
      expect(response.body).to include('<p>Name: Space B</p>')
      expect(response.body).to include('<p>Name: Space C</p>')
    end
  end

  # GET /spaces/:date
  xcontext 'GET /spaces/:date' do
    it 'should return a list of spaces with a given date' do
      response = get('/spaces/2022-02-14')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Location: Leeds</p>')
      expect(response.body).to include('<p>Name: Space B</p>')
      expect(response.body).to include('<p>Name: Space C</p>')
    end
  end

  # GET /spaces/:location
  xcontext 'GET /spaces/:location' do
    it 'should return a list of spaces with a given location' do
      response = get('/spaces/leeds')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Location: Leeds</p>')
      expect(response.body).to include('<p>Name: Space B</p>')
      expect(response.body).to include('<p>Name: Space C</p>')
    end
  end
end
