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
    expect(spaces[0].makerId).to eq 1 # => 1
    expect(spaces[0].available_date).to eq ['2022-02-14', '2022-02-15']

    expoect(spaces[1].id).to eq  2
    expoect(spaces[1].name).to eq 'Space B'
    expoect(spaces[1].makerId).to eq 2
    expoect(spaces[1].available_date).to eq ['2022-02-16', '2022-02-14']
  end
end