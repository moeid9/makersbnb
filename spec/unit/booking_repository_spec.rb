require_relative "../../lib/booking.rb"
require_relative "../../lib/booking_repository.rb"

describe BookingRepository do
  def reset_bookings_table
    seed_sql = File.read("spec/seeds/seeds_bookings.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_bookings_table
    @repo = BookingRepository.new
  end

  it "returns all the bookings" do
    bookings = @repo.all

    expect(bookings.length).to eq 3
    expect(bookings.first.id).to eq 1
    expect(bookings.first.requested_space_id).to eq 1
  end

  it "creates a new booking for a space" do # Moeid
    new_booking = Bookings.new

    new_booking.confirmed = false
    new_booking.requested_space_id = 3
    new_booking.requested_user_id = 2
    @repo.create(new_booking)
    selection = @repo.find_by_booking_id(4)
    expect(new_booking.confirmed).to eq false
    expect(new_booking.requested_space_id).to eq 3
    expect(new_booking.requested_user_id).to eq 2
  end

  it "should return a booking when an booking_id is given" do # Terry
    booking = @repo.find_by_booking_id(3)

    expect(booking.id).to eq 3
    expect(booking.confirmed).to eq "f"
    expect(booking.requested_space_id).to eq 3
    expect(booking.requested_user_id).to eq 3
  end

  it "should confirm a booked as completed" do # Chris
    @repo.confirm(1, 1)

    booked = @repo.find_by_booking_id(1)
    expect(booked.confirmed).to eq "t"
  end

  it "should return single space object when space_id is given" do # Omar
    booking = @repo.find_by_space_id(1)

    expect(booking.confirmed).to eq "t"
    expect(booking.requested_space_id).to eq 1
    expect(booking.requested_user_id).to eq 1
  end
end
