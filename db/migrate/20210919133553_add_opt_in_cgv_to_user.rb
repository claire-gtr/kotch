class AddOptInCgvToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :optin_cgv, :boolean, default: false
  end
end
