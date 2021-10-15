class AddMessagesReadedToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :messages_readed, :boolean, default: false, null: false
  end
end
