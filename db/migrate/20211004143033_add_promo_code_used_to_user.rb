class AddPromoCodeUsedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :promo_code_used, :boolean, default: false, null: false
  end
end
