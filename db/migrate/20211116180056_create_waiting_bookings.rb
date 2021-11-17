class CreateWaitingBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :waiting_bookings do |t|
      t.string :user_email, null: false
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
