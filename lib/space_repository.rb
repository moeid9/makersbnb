require_relative "./database_connection.rb"
require_relative "./space.rb"

class SpaceRepository
  def all
    sql = "SELECT id, name, description, price, location, maker_id, date, available FROM spaces;"
    result_set = DatabaseConnection.exec_params(sql, [])

    spaces = []

    result_set.each do |record|
      space = Space.new
      space.id = record["id"].to_i
      space.name = record["name"]
      space.description = record["description"]
      space.price = record["price"].to_i
      space.location = record["location"]
      space.date = record["date"]
      space.available = record["available"]
      space.maker_id = record["maker_id"].to_i

      spaces << space
    end
    return spaces.select { |space| space.available == "t" }
  end

  def create(space)
    sql = "INSERT INTO spaces (name, description, price, location, maker_id, date, available) VALUES ($1, $2, $3, $4, $5, $6, $7);"
    params = [space.name, space.description, space.price, space.location, space.maker_id, space.date, space.available]
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
    sql = "DELETE FROM spaces WHERE id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [id])

    # Nothing returned
  end

  def find_by_id(id)
    sql = "SELECT id, name, description, price, location, maker_id, date, available FROM spaces WHERE id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [id])

    space = Space.new
    space.id = result_set[0]["id"].to_i
    space.name = result_set[0]["name"]
    space.description = result_set[0]["description"]
    space.price = result_set[0]["price"].to_i
    space.location = result_set[0]["location"]
    space.date = result_set[0]["date"]
    space.available = result_set[0]["available"]
    space.maker_id = result_set[0]["maker_id"].to_i

    return space
  end

  def find_by_date(date)
    sql = "SELECT id, name, description, price, location, maker_id, date, available FROM spaces WHERE date = $1;"
    result_set = DatabaseConnection.exec_params(sql, [date])

    spaces = []

    result_set.each do |record|
      space = Space.new
      space.id = record["id"].to_i
      space.name = record["name"]
      space.description = record["description"]
      space.price = record["price"].to_i
      space.location = record["location"]
      space.date = record["date"]
      space.available = record["available"]
      space.maker_id = record["maker_id"].to_i

      spaces << space
    end
    return spaces
  end

  def find_by_maker(maker_id)
    sql = "SELECT id, name, description, price, location, maker_id, date, available FROM spaces WHERE maker_id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [maker_id])

    spaces = []

    result_set.each do |record|
      space = Space.new
      space.id = record["id"].to_i
      space.name = record["name"]
      space.description = record["description"]
      space.price = record["price"].to_i
      space.location = record["location"]
      space.date = record["date"]
      space.available = record["available"]
      space.maker_id = record["maker_id"].to_i

      spaces << space
    end
    return spaces
  end

  def find_by_location(location)
    sql = "SELECT id, name, description, price, location, maker_id, date, available FROM spaces WHERE location = $1;"
    result_set = DatabaseConnection.exec_params(sql, [location])

    spaces = []

    result_set.each do |record|
      space = Space.new
      space.id = record["id"].to_i
      space.name = record["name"]
      space.description = record["description"]
      space.price = record["price"].to_i
      space.location = record["location"]
      space.date = record["available_date"]
      space.available = record["available"]
      space.maker_id = record["maker_id"].to_i

      spaces << space
    end
    return spaces
  end
end
