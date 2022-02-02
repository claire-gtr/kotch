class FriendRequest < ApplicationRecord
  belongs_to :requestor, foreign_key: 'requestor_id', class_name: 'User'
  belongs_to :receiver, foreign_key: 'receiver_id', class_name: 'User'

  validates :requestor, uniqueness: { scope: :receiver }
end
