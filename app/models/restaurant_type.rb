class RestaurantType < ApplicationRecord
  validates :type_name, :type_name_en, presence: true
end
