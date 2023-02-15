require_relative './user'
require 'bcrypt'

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

  def find_by_email(email)
    sql = 'SELECT id, name, email, password FROM users WHERE email = $1'
    result_set = DatabaseConnection.exec_params(sql, [email])

    result_set.each do |result|
      user = Users.new
      user.id = result['id']
      user.name = result['name']
      user.email = result['email']
      user.password = result['password']
      return user
    end
  end

	def create(user)
    encrypted_password = BCrypt::Password.create(user.password)
    sql = "INSERT INTO users (name, email, password) VALUES('#{user.name}', '#{user.email}', '#{encrypted_password}');"
    result_set = DatabaseConnection.exec_params(sql, [])
    return result_set
	end

  def sign_in(email, submitted_password)
    user = find_by_email(email)

    return nil if user.nil?

    # Compare the submitted password with the encrypted one saved in the database
    if user.password == BCrypt::Password.new(user.password)
      return true
    else
      return false
    end
  end

end