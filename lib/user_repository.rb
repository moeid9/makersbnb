require_relative './user'

class UsersRepository

	# Selecting all records
	# No arguments
	def all
		sql = 'SELECT * FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])
    users = []
    result_set.each do |record|
      user = Users.new
      user.id = record['id']
      user.name = record['name']
      user.email = record['email']
      user.password = record['password']
      users << user
    end
    return users
	end

	# Gets a single record by its ID
	# One argument: the id (number)
	def find(id)
    sql = "SELECT name, email, password FROM users WHERE id = $1"
    result_set = DatabaseConnection.exec_params(sql, [id])

    result_set.each do |record|
      user = Users.new
      user.id = record['id']
      user.name = record['name']
      user.email = record['email']
      user.password = record['password']
      return user
    end

	end

	def find_by_name(name)
    sql = "SELECT name, email, password FROM users WHERE name = $1"
    result_set = DatabaseConnection.exec_params(sql, [name])

    result_set.each do |record|
      user = Users.new
      user.id = record['id']
      user.email = record['email']
      user.password = record['password']
      return user
    end
	end

	def create(user)
    sql = "INSERT INTO users (name, email, password) VALUES('#{user.name}', '#{user.email}', '#{user.password}');"
    result_set = DatabaseConnection.exec_params(sql, [])
    return result_set
	end
end