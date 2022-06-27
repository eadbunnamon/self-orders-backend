class Category < ApplicationRecord
  belongs_to :restaurant
  has_many :items

  validates :name, :name_en, presence: true
  validates :name, uniqueness: { scope: :restaurant_id }

  default_scope { order(created_at: :asc) }
end
