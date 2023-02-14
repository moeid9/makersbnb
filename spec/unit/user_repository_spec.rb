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
    expect(users[0].password).to eq 'pikipi'
    
    expect(users[1].id).to eq '2'
    expect(users[1].name).to eq 'Dawn Misty'
    expect(users[1].email).to eq 'water@pokemon.com'
    expect(users[1].password).to eq 'Pilup'
  end

	it 'finds a single entry' do
    repo = UsersRepository.new

    selection = repo.find(1)

    expect(selection.name).to eq 'Ash Ketchum'
    expect(selection.email).to eq 'pikachu@pokemon.com'
    expect(selection.password).to eq 'pikipi'
  end

	it 'finds an entry by the name and returns a record' do
    repo = UsersRepository.new

    selection = repo.find_by_name('Brock Rocky')
    expect(selection.email).to eq 'steelix@pokemon.com'
    expect(selection.password).to eq 'Women<3'
  end

	it 'creates a new user and returns its record' do
		repo = UsersRepository.new
		new_user = Users.new
		new_user.name = 'Mitch Patek'
		new_user.email = 'mitch@email.com'
    new_user.password = 'itchymitch11'
		repo.create(new_user)
		selection = repo.find(4)
    expect(selection.name).to eq 'Mitch Patek'
    expect(selection.email).to eq 'mitch@email.com'
    expect(selection.password).to eq 'itchymitch11'
	end
end