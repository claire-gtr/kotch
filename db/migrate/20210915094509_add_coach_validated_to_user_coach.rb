class AddCoachValidatedToUserCoach < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :validated_coach, :boolean, default: false
  end
end
