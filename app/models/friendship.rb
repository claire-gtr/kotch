class Friendship < ApplicationRecord
  belongs_to :firend_a, foreign_key: 'firend_a_id', class_name: 'User'
  belongs_to :friend_b, foreign_key: 'friend_b_id', class_name: 'User'
end
