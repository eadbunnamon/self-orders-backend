class RestaurantType < ApplicationRecord
  has_many :restaurants

  validates :type_name, :type_name_en, presence: true
  validates :constant_type, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  # validates :constant_type, inclusion: { in: %w[general, buffet] }
end
