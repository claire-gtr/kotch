class AddNicknameToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :nickname, :string
  end
end
