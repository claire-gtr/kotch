class AddPublicToLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :public, :boolean, default: false
  end
end
