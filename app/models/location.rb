class Location < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  geocoded_by :name
  after_validation :geocode, if: :will_save_change_to_name?
end
