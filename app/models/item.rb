class Item < ApplicationRecord
  belongs_to :category
  has_one :image, as: :imageable

  validates :name, :name_en, presence: true
  validates :price, presence: true
end
