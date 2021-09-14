class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_id
      t.string :end_date
      t.integer :status

      t.timestamps
    end
  end
end
