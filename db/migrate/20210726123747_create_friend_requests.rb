class CreateFriendRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_requests do |t|
      t.integer :requestor_id, null: false
      t.integer :receiver_id, null: false

      t.timestamps null: false
    end

    add_index :friend_requests, :requestor_id
    add_index :friend_requests, :receiver_id
    add_index :friend_requests, [:requestor_id, :receiver_id], unique: true
  end
end
