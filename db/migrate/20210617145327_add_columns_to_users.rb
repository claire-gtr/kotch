class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :address, :string
    add_column :users, :gender, :integer
    add_column :users, :sport_habits, :integer
    add_column :users, :physical_pain, :integer
    add_column :users, :level, :integer
    add_column :users, :intensity, :integer
    add_column :users, :admin, :boolean, default: false
    add_column :users, :coach, :boolean, default: false
    add_column :users, :interests, :text, array: true, default: []
  end
end
