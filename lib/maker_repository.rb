require_relative './maker'

class MakersRepository

	# Selecting all records
	# No arguments
	def all
		sql = 'SELECT * FROM makers;'
    result_set = DatabaseConnection.exec_params(sql, [])
    makers = []
    result_set.each do |record|
      maker = Makers.new
      maker.id = record['id']
      maker.name = record['name']
      maker.email = record['email']
      maker.password = record['password']
      makers << maker
    end
    return makers
	end

	# Gets a single record by its ID
	# One argument: the id (number)
	def find(id)
    sql = "SELECT name, email, password FROM makers WHERE id = $1"
    result_set = DatabaseConnection.exec_params(sql, [id])

    result_set.each do |record|
      maker = Makers.new
      maker.id = record['id']
      maker.name = record['name']
      maker.email = record['email']
      maker.password = record['password']
      return maker
    end

	end

	def find_by_name(name)
    sql = "SELECT name, email, password FROM makers WHERE name = $1"
    result_set = DatabaseConnection.exec_params(sql, [name])

    result_set.each do |record|
      maker = Makers.new
      maker.id = record['id']
      maker.email = record['email']
      maker.password = record['password']
      return maker
    end
	end

	def create(maker)
    sql = "INSERT INTO makers (name, email, password) VALUES('#{maker.name}', '#{maker.email}', '#{maker.password}');"
    result_set = DatabaseConnection.exec_params(sql, [])
    return result_set
	end
end