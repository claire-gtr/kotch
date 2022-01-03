class CreateEmployments < ActiveRecord::Migration[6.0]
  def change
    create_table :employments do |t|
      t.references :enterprise, null: false, foreign_key: { to_table: :users }
      t.references :employee, null: false, foreign_key: { to_table: :users }
      t.boolean :accepted

      t.timestamps
    end
  end
end
