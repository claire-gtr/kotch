class AddCompanyDiscoverToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :company_discover, :integer
  end
end
