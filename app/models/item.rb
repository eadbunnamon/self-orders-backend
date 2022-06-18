class Item < ApplicationRecord
  belongs_to :category
  has_one :image, as: :imageable

  accepts_nested_attributes_for :image

  validates :name, :name_en, presence: true
end
