class CreateUserCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_codes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :promo_code, null: false, foreign_key: true

      t.timestamps
    end
  end
end
