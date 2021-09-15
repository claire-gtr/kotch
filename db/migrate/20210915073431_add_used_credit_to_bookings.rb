class AddUsedCreditToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :used_credit, :boolean, default: false
  end
end
