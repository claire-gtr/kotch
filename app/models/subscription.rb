class Subscription < ApplicationRecord
  belongs_to :user
  enum status: { pending: 0, active: 1, trialing: 2, incomplete: 3, incomplete_expired: 4, past_due: 5, canceled: 6, unpaid: 7, trial_ended: 8, trial_coupon_code: 9}
end
