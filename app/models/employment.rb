class Employment < ApplicationRecord
  belongs_to :enterprise, class_name: 'User', foreign_key: "enterprise_id"
  belongs_to :employee, class_name: 'User', foreign_key: "employee_id"
end
