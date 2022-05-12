class Category < ApplicationRecord
  belongs_to :restaurant
  has_many :items

  validates :name, :name_en, presence: true
end
