class Restaurant < ApplicationRecord
  has_many :categories
  has_many :tables
  has_one :image, as: :imageable
  belongs_to :restaurant_type
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :image
  
  validates :name, :name_en, presence: true
end
