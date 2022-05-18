class Staff < ApplicationRecord
  belongs_to :restaurant
  belongs_to :role

  validates :name, :phone_number, presence: true
end
