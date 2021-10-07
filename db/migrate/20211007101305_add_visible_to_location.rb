class AddVisibleToLocation < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :visible, :boolean, default: false, null: false
  end
end
