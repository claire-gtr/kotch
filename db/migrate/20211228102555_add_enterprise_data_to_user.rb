class AddEnterpriseDataToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :status, :integer, default: 0, null: false
    add_column :users, :enterprise_name, :string
    add_column :users, :enterprise_code, :string
  end
end
