class Item < ApplicationRecord
  belongs_to :category

  validates :name, :name_en, presence: true
  validates :price, presence: true
end
