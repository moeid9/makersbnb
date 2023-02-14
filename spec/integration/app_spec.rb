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
    end
  end
end
