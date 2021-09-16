class AddFocusToLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :focus, :text
  end
end
