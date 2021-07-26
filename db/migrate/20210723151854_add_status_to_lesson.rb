class AddStatusToLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :status, :string, default: "pending"
  end
end
