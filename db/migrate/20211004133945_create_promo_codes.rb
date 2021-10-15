class CreatePromoCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :promo_codes do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
