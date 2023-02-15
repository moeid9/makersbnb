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


  context 'GET /makers/login' do
    it 'should get the Makers Login page' do
      response = get('/makers/login')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Login to your Makers Account</h1>')
      expect(response.body).to include('<form action="/makers/login" method="POST">')
      expect(response.body).to include('<input type="text" name="email" />')
      expect(response.body).to include('<input type="text" name="password" />')
    end
  end

  context 'GET /makers/signup' do
    it 'should get the Sign up page' do
      response = get('/makers/signup')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Signup as a Maker</h1>')
      expect(response.body).to include('<form action="/makers/signup" method="POST">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="email" />')
      expect(response.body).to include('<input type="text" name="password" />')
    end
  end

  context 'POST /makers/login' do
    it 'should log the user in' do
      response = post(
        '/makers/login',
        email: 'black_jack@email.com',
        password: 'giant'
      )

      expect(response.status).to eq(200)
    end
  end

  context 'POST /makers/signup' do
    it 'should get the signup page' do
      response = post(
        '/makers/signup',
        name: 'Jack Daniels',
        email: 'jack@email.com',
        password: 'giantqwe'
      )

      expect(response.status).to eq(200)
    end
  end

  context 'GET /users/signup' do
    it 'should get the signup page for users' do
    response = get('/users/signup')
    
    expect(response.status).to eq(200)
    expect(response.body).to include('<h1>User Signup</h1>')
    expect(response.body).to include('<form action="/users/signup" method="POST">')
    expect(response.body).to include('<input type="text" name="name" />')
    expect(response.body).to include('<input type="text" name="email" />')
    expect(response.body).to include('<input type="text" name="password" />')
    end
  end

  context 'POST /users/signup' do
    it 'should get the signup page for users' do
      response = post(
        'users/signup',
        name: 'David Beckham',
        email: 'david@email.com',
        password: 'football'
      )

      expect(response.status).to eq(200)
    end
  end

  context 'GET /users/login' do
    it 'should get the Users Login page' do
      response = get('/users/login')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Login to your Account</h1>')
      expect(response.body).to include('<form action="/users/login" method="POST">')
      expect(response.body).to include('<input type="text" name="email" />')
      expect(response.body).to include('<input type="text" name="password" />')
    end
  end

  context 'POST /users/login' do
    it 'should log the user in' do
      response = post(
        '/users/login',
        email: 'pikachu@pokemon.com',
        password: 'pikipi'
      )
      
      expect(response.status).to eq(302)
    end
  end

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
