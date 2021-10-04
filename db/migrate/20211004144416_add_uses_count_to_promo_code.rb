class AddUsesCountToPromoCode < ActiveRecord::Migration[6.0]
  def change
    add_column :promo_codes, :uses_count, :integer, default: 0
  end
end
