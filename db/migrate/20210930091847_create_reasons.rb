class CreateReasons < ActiveRecord::Migration[6.0]
  def change
    create_table :reasons do |t|
      t.string :title, null: false
      t.string :other_text
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
