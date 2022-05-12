class Restaurant < ApplicationRecord
  has_many :categories
  has_many :tables
  
  validates :name, :name_en, presence: true
  validates :open_time, :close_time, presence: true
end
