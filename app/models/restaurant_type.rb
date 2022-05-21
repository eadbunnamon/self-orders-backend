class RestaurantType < ApplicationRecord
  has_many :restaurants

  validates :type_name, :type_name_en, presence: true

  enum :restaurant_type, { general: 'general', buffet: 'buffet' }
end
