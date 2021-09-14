class CreatePackOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :pack_orders do |t|
      t.string :state
      t.float :amount
      t.references :user, null: false, foreign_key: true
      t.string :checkout_session_id
      t.integer :credit_count

      t.timestamps
    end
  end
end
