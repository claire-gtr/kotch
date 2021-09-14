class AddCreditCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :credit_count, :integer, default: 0
  end
end
