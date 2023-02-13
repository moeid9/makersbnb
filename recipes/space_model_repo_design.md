
## 1. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- (file: spec/seeds_spaces.sql)

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE spaces RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO spaces (name, description, price, location, makerId, available_date) VALUES ('Space A', 'It is nice', 100, 'London', 1, ['2022-02-13', '2022-02-15']);
INSERT INTO spaces (name, description, price, location, makerId, available_date) VALUES ('Space B', 'It is awesome', 80, 'Leeds', 2, ['2022-02-16', '2022-02-14']);
INSERT INTO spaces (name, description, price, location, makerId, available_date) VALUES ('Space C', 'It is awesome', 50, 'Leeds', 2, ['2022-02-14', '2022-02-15']);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_spaces.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: spaces

# Model class
# (in lib/space.rb)
class Space
end

# Repository class
# (in lib/space_repository.rb)
class SpaceRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: spaces

# Model class
# (in lib/space.rb)

class Space
  attr_accessor :id, :name, :location, :price, :description, :makerId, :available_date
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: spaces

# Repository class
# (in lib/spaces_repository.rb)

class SpaceRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM students;

    # Returns an array of Student objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM students WHERE id = $1;

    # Returns a single Student object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(space)
  end

  def update(id)
  end

  def delete(id)
  end

  def find_by_date(date)
    # Executes a SQL query which searches the available dates to find which spaces are available

    # Returns a list of Space objects
  end

  def find_by_maker(makerId)
    # Executes a SQL query which searches spaces to find which spaces are owned by the given maker

    # Returns a list of Space objects
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all spaces

repo = SpaceRepository.new

spaces = repo.all

spaces.length # =>  3

spaces[0].id # =>  1
spaces[0].name # =>  'Space A'
spaces[0].makerId # => 1
spaces[0].available_date # => ['2022-02-14', '2022-02-15']

spaces[1].id # =>  2
spaces[1].name # =>  'Space B'
spaces[1].makerId # => 2
spaces[1].available_date # => ['2022-02-16', '2022-02-14']


# 2
# Get a single space

repo = SpaceRepository.new

space = repo.find(1)

space.id # =>  1
space.name # =>  'Space A'
space.makerId # => 1
space.available_date # => ['2022-02-14', '2022-02-15']

# 3
# Creates a space

repo = SpaceRepository.new

new_space = double :space, name: "Space A"

repo.create(new_space)

repo.all.last.name # => "Space A"


# 4
# Updates a space

repo = SpaceRepository.new

repo.update(1, { name: "Space B", price: 200 })

repo.find(1).name # => "Space B"
repo.find(1).price # => 200

# 5
# Deletes a space

repo = SpaceRepository.new

repo.delete(1)

repo.all.first.id # => 2

# 6
# Returns a list of available spaces

repo = SpaceRepository.new

spaces = repo.find_by_date('2022-02-14')

spaces.length # => 2
spaces[0].id # => 2
spaces[1].name # => "Space C"

# 7
# Returns a list of spaces owned by a maker

repo = SpaceRepository.new

spaces = repo.find_by_maker(1)

spaces.length # => 1
spaces[0].id # => 1
spaces[0].name # => "Space A"


```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_spaces_table
  seed_sql = File.read('spec/seeds_spaces.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_spaces_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._