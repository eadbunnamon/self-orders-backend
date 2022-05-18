class Restaurant < ApplicationRecord
  has_many :categories
  has_many :tables
  has_many :images, as: :imageable
  belongs_to :restaurant_type
  has_many :staffs
  
  validates :name, :name_en, presence: true
  validates :open_time, :close_time, presence: true
end
