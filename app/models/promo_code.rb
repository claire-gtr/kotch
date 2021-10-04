class PromoCode < ApplicationRecord
  validates :name,
            presence: true,
            exclusion: { in: [""], message: "%{value} n'est pas autorisé." }

  validates :uses_count,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_create :set_name_uppercase

  private

  def set_name_uppercase
    name.upcase!
  end
end
