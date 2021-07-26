class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.integer :friend_a_id, null: false
      t.integer :friend_b_id, null: false

      t.timestamps null: false
    end

    add_index :friendships, :friend_a_id
    add_index :friendships, :friend_b_id
    add_index :friendships, [:friend_a_id, :friend_b_id], unique: true
  end
end
