class Partner < ApplicationRecord
  before_save :remove_empty_spaces

  def remove_empty_spaces
    self.domain_name = self.domain_name.gsub(/\s+/, '')
    self.coupon_code = self.coupon_code.gsub(/\s+/, '')
  end
end
