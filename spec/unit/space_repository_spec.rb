require_relative '../../lib/space.rb'
require_relative '../../lib/space_repository.rb'

RSpec.describe SpaceRepository do
  def reset_spaces_table
    seed_sql = File.read('spec/seeds/seeds_spaces.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
  
  before(:each) do 
    reset_spaces_table
    @repo = SpaceRepository.new
  end
  
  it "Gets all spaces" do
    spaces = @repo.all

    expect(spaces.length).to eq 3

    expect(spaces[0].id).to eq 1 # =>  1
    expect(spaces[0].name).to eq 'Space A' # =>  'Space A'
    expect(spaces[0].maker_id).to eq 1 # => 1
    expect(spaces[0].available_date).to eq '2022-02-13'

    expect(spaces[1].id).to eq  2
    expect(spaces[1].name).to eq 'Space B'
    expect(spaces[1].maker_id).to eq 2
    expect(spaces[1].available_date).to eq '2022-02-14'
  end

  it "creates a space" do 
    new_space = double :space, name: "Space A", description: "It's nice", location: "london", price: 50, maker_id: 1, available_date: '2023-02-13'

    @repo.create(new_space)
        
    expect(@repo.all.last.name).to eq "Space A"
  end
  
  it "updates a space" do 
    @repo.update(1, { name: "Space B", price: 200 })
        
    expect(@repo.find_by_id(1).name).to eq "Space B"
    expect(@repo.find_by_id(1).price).to eq 200
  end

  it "deletes a space" do 
    @repo.delete(1)
        
    expect(@repo.all.first.id).to eq 2
  end

  it "Find a space by ID" do
    space_to_find = double :space, id: 1, name: "Space A", description: "It's nice", location: "london", maker_id: 1, available_date: "2023-02-13"

    space = @repo.find_by_id(space_to_find.id)

    expect(space.id).to eq 1
    expect(space.name).to eq 'Space A'
    expect(space.maker_id).to eq 1
    expect(space.available_date).to eq '2022-02-13'
  end
  
end