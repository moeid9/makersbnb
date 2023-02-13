require_relative './database_connection.rb'
require_relative './space.rb'

class SpaceRepository
  def all
    sql = 'SELECT id, name, description, price, location, maker_id, available_date FROM spaces;'
    result_set = DatabaseConnection.exec_params(sql, [])

    spaces = []
    
    result_set.each do |record|
      space = Space.new
      space.id = record['id'].to_i
      space.name = record['name']
      space.description = record['description']
      space.price = record['price'].to_i
      space.location = record['location']
      space.maker_id = record['maker_id'].to_i
      space.available_date = record['available_date']

      spaces << space
    end
    return spaces
  end

  def create(space)
    sql = "INSERT INTO spaces (name, description, price, location, maker_id, available_date) VALUES ($1, $2, $3, $4, $5, $6);"
    params = [space.name, space.description, space.price, space.location, space.maker_id, space.available_date]
    result_set = DatabaseConnection.exec_params(sql, params)

    # Nothing returned
  end

  def update(id, hash)
    hash.each do |key, value|
      sql = "UPDATE spaces SET #{key}='#{value}' WHERE id = $1;"
      result_set = DatabaseConnection.exec_params(sql, [id])
    end

    # Nothing returned
  end

  def delete(id)
    sql = 'DELETE FROM spaces WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])
    
    # Nothing returned
  end

  def find_by_id(id)
    sql = 'SELECT id, name, description, price, location, maker_id, available_date FROM spaces WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])
    
    space = Space.new
    space.id = result_set[0]['id'].to_i
    space.name = result_set[0]['name']
    space.description = result_set[0]['description']
    space.price = result_set[0]['price'].to_i
    space.location = result_set[0]['location']
    space.maker_id = result_set[0]['maker_id'].to_i
    space.available_date = result_set[0]['available_date']

    return space
  end

  

end