class Table < ApplicationRecord
  belongs_to :restaurant
  
  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id }
end
