class Item < ApplicationRecord
  belongs_to :category
  has_one :image, as: :imageable
  has_many :options, dependent: :destroy

  attr_accessor :image_file

  accepts_nested_attributes_for :options, allow_destroy: true
  # validates_associated :options

  validates :name, :name_en, :price, presence: true
  validates :name, :name_en, uniqueness: { scope: :category_id }
end
