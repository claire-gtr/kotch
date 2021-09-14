class AddDefaultValueToSubStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :subscriptions, :status, :integer, default: 0
  end
end
