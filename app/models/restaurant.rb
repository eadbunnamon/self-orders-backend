class Restaurant < ApplicationRecord
  has_many :categories
  has_many :tables
  has_many :images, as: :imageable
  belongs_to :restaurant_type
  has_and_belongs_to_many :users
  
  validates :name, :name_en, presence: true
  validates :open_time, :close_time, presence: true
end
