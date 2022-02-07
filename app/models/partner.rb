class Partner < ApplicationRecord
  before_save :remove_empty_spaces

  validates :coupon_code, presence: true, uniqueness: true
  validates :domain_name, presence: true, uniqueness: true
  validates :percentage, presence: true
  validates :name, presence: true

  def remove_empty_spaces
    self.domain_name = self.domain_name.gsub(/\s+/, '')
    self.coupon_code = self.coupon_code.gsub(/\s+/, '')
  end
end
