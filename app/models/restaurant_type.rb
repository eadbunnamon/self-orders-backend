class RestaurantType < ApplicationRecord
  has_many :restaurants

  validates :type_name, :type_name_en, presence: true
end
