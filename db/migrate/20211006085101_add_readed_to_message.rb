class AddReadedToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :readed, :boolean, default: false, null: false
  end
end
