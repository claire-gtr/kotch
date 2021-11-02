class UserCode < ApplicationRecord
  belongs_to :user
  belongs_to :promo_code
end
