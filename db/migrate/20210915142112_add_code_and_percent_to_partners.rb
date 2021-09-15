class AddCodeAndPercentToPartners < ActiveRecord::Migration[6.0]
  def change
    add_column :partners, :coupon_code, :string
    add_column :partners, :percentage, :integer
  end
end
