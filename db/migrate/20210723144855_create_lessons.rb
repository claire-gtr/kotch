class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.references :user, null: true, foreign_key: true
      t.string :sport_type
      t.string :location
      t.datetime :date

      t.timestamps
    end
  end
end
