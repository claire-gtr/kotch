class AddLocationReferenceToLesson < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :location, :string
    add_reference :lessons, :location, index: true
  end
end
