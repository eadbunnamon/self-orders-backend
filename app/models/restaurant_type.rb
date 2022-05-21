class RestaurantType < ApplicationRecord
  has_many :restaurants

  validates :type_name, :type_name_en, presence: true
  validates_uniqueness_of :constant_type

  enum :constant_type, { general: 'general', buffet: 'buffet' }
end
