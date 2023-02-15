require 'user_repository'
  
describe UsersRepository do
  def reset_users_table
      seed_sql = File.read('spec/seeds/seeds_users.sql')
      connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
      connection.exec(seed_sql)
  end

  before(:each) do 
    reset_users_table
  end
  
  it 'returns a list of users' do
    repo = UsersRepository.new
    users = repo.all
    expect(users.length).to eq 3
    expect(users[0].id).to eq '1'
    expect(users[0].name).to eq 'Ash Ketchum'
    expect(users[0].email).to eq 'pikachu@pokemon.com'
    expect(users[0].password).to eq '$2a$12$ldp6Sfhx1heNDgHzN3iREO19XfdlSnZs8sgGWOKEFeO3Df3UO3.1q'
    
    expect(users[1].id).to eq '2'
    expect(users[1].name).to eq 'Dawn Misty'
    expect(users[1].email).to eq 'water@pokemon.com'
    expect(users[1].password).to eq '$2a$12$Jv7iy8qnvJBgrqsIQGt/Gu3fHJVa1K7eq7n6V/dD6.QMEX7jmcuiy'
  end

	it 'finds a single entry' do
    repo = UsersRepository.new

    selection = repo.find(1)

    expect(selection.name).to eq 'Ash Ketchum'
    expect(selection.email).to eq 'pikachu@pokemon.com'
    expect(selection.password).to eq '$2a$12$ldp6Sfhx1heNDgHzN3iREO19XfdlSnZs8sgGWOKEFeO3Df3UO3.1q'
  end

	it 'finds an entry by the email and returns a record' do
    repo = UsersRepository.new

    selection = repo.find_by_email('steelix@pokemon.com')
    expect(selection.name).to eq 'Brock Rocky'
    expect(selection.password).to eq '$2a$12$zPrhw0IggUF.1KfQ2f0UJOpqscOEFktfMa/tpMNuKP30aBo4IzlP.'
  end

	it 'creates a new user and returns its record' do
		repo = UsersRepository.new
		new_user = Users.new
		new_user.name = 'Mitch Patek'
		new_user.email = 'mitch@email.com'
    new_user.password = 'itchymitch11'
		repo.create(new_user)
    expect(repo.sign_in(new_user.email, new_user.password)).to be true
		# selection = repo.find(4)
    # expect(selection.name).to eq 'Mitch Patek'
    # expect(selection.email).to eq 'mitch@email.com'
    # expect(selection.password).to eq '$2a$12$H5BSXEvlXr.CZBhSyhaqJebf2PeWOKu9WoeliaWrnY/N3teQrqOBS'
	end
end