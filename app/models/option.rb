class Option < ApplicationRecord
  belongs_to :item

  validates :size, :price, presence: true
  validates :size, uniqueness: { scope: :item_id }
end
