class Restaurant < ApplicationRecord
  validates :name, :name_en, presence: true
  validates :open_time, :close_time, presence: true
end
