class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :content
      t.string :title

      t.timestamps
    end
  end
end
