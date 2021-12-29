class AddReccurencyToLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :reccurency, :integer, default: 0, null: false
  end
end
