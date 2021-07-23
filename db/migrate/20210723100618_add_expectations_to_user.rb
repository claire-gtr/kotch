class AddExpectationsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :expectations, :integer
  end
end
