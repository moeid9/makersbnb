# create booking moeid
# remove booking when it's done
# should interact with spaces to remove booked spaces
# only makers should be able to confirm bookings
# user should be able to book spaces
# user should be able to see their booking requests
# user and maker should be able to see their confirmed requests
require_relative "./booking"

class BookingRepository
  def all
    sql = "SELECT * FROM bookings;"
    result_set = DatabaseConnection.exec_params(sql, [])
    bookings = []
    result_set.each do |record|
      booking = Bookings.new
      booking.id = record["id"].to_i
      booking.confirmed = record["confirmed"]
      booking.requested_space_id = record["requested_space_id"].to_i
      booking.requested_user_id = record["requested_user_id"].to_i
      bookings << booking
    end
    return bookings
  end

  def create(booking) #moeid
    sql = "INSERT INTO bookings (confirmed, requested_space_id, requested_user_id) VALUES('#{booking.confirmed}', '#{booking.requested_space_id}', '#{booking.requested_user_id}');"
    result_set = DatabaseConnection.exec_params(sql, [])
    return result_set
  end

  def find_by_booking_id(id) #terry
    sql = "SELECT id, confirmed, requested_space_id, requested_user_id FROM bookings WHERE id = $1;"
    result = DatabaseConnection.exec_params(sql, [id]).first

    booking = Bookings.new
    booking.id = result["id"].to_i
    booking.confirmed = result["confirmed"]
    booking.requested_space_id = result["requested_space_id"].to_i
    booking.requested_user_id = result["requested_user_id"].to_i

    return booking
  end

  def confirm(id, space_id) #maker -chris
    confirm_sql = "UPDATE bookings SET confirmed=TRUE WHERE id = $1;"
    DatabaseConnection.exec_params(confirm_sql, [id])
    reject_others_sql = "DELETE FROM bookings WHERE id != $1 AND requested_space_id = $2"
    DatabaseConnection.exec_params(reject_others_sql, [id, space_id])
  end

  def find_by_space_id(space_id) #dora
    sql = "SELECT id, confirmed, requested_space_id, requested_user_id FROM bookings WHERE requested_space_id = $1;"
    result = DatabaseConnection.exec_params(sql, [space_id]).first

    booking = Bookings.new
    booking.id = result["id"].to_i
    booking.confirmed = result["confirmed"]
    booking.requested_space_id = result["requested_space_id"].to_i
    booking.requested_user_id = result["requested_user_id"].to_i
    return booking
  end

  def find_by_user_id(user_id) #Dora
    sql = "SELECT 
            bookings.id, bookings.confirmed, spaces.name, spaces.date
          FROM bookings 
          JOIN spaces ON bookings.requested_space_id = spaces.id
          WHERE
            bookings.requested_user_id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [user_id])

    bookings = []

    result_set.each do |record|
      bookings << {
        id: record["id"],
        confirm: record["confirmed"],
        space_name: record["name"],
        date: record["date"],
      }
    end

    # booking = Bookings.new
    # booking.id = result["id"].to_i
    # booking.confirmed = result["confirmed"]
    # booking.requested_space_id = result["requested_space_id"].to_i
    # booking.requested_user_id = result["requested_user_id"].to_i

    return bookings
  end

  def find_by_maker_id(maker_id)
    sql = "SELECT 
            spaces.id, spaces.name AS space_name, spaces.description, users.name AS user_name
          FROM 
            bookings 
          JOIN spaces ON bookings.requested_space_id = spaces.id 
          JOIN makers ON makers.id = spaces.maker_id
          JOIN users ON bookings.requested_user_id = users.id
          WHERE 
            bookings.confirmed = false
          AND
            makers.id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [maker_id])

    bookings = []

    result_set.each do |record|
      bookings << {
        id: record["id"],
        space_name: record["space_name"],
        space_description: record["description"],
        user_name: record["user_name"],
      }
    end

    return bookings
  end

  def delete(id)
    sql = "DELETE FROM bookings WHERE id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [id])
  end
end
