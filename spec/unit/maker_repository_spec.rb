require 'maker_repository'
  
describe MakersRepository do
  def reset_makers_table
      seed_sql = File.read('spec/seeds/seeds_makers.sql')
      connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
      connection.exec(seed_sql)
  end

  before(:each) do 
    reset_makers_table
  end
  
  it 'returns a list of makers' do
    repo = MakersRepository.new
    makers = repo.all
    expect(makers.length).to eq 3
    expect(makers[0].id).to eq '1'
    expect(makers[0].name).to eq 'Jack Black'
    expect(makers[0].email).to eq 'black_jack@email.com'
    expect(makers[0].password).to eq 'giant'
    
    expect(makers[1].id).to eq '2'
    expect(makers[1].name).to eq 'Micheal Jackson'
    expect(makers[1].email).to eq 'dance@email.com'
    expect(makers[1].password).to eq 'monkey'
  end

	it 'finds a single entry' do
    repo = MakersRepository.new

    selection = repo.find(1)

    expect(selection.name).to eq 'Jack Black'
    expect(selection.email).to eq 'black_jack@email.com'
    expect(selection.password).to eq 'giant'
  end

	it 'finds an entry by the name and returns a record' do
    repo = MakersRepository.new

    selection = repo.find_by_name('Penelope Cruz')
    expect(selection.email).to eq 'actor@email.com'
    expect(selection.password).to eq 'Women<3'
  end

	it 'creates a new maker and returns its record' do
		repo = MakersRepository.new
		new_maker = Makers.new
		new_maker.name = 'Dora Foggy'
		new_maker.email = 'dora@email.com'
    new_maker.password = 'Makersaca'
		repo.create(new_maker)
		selection = repo.find(4)
    expect(selection.name).to eq 'Dora Foggy'
    expect(selection.email).to eq 'dora@email.com'
    expect(selection.password).to eq 'Makersaca'
	end
end