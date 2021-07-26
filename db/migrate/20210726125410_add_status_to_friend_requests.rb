class AddStatusToFriendRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :friend_requests, :status, :string, default: "pending"
  end
end
