class Option < ApplicationRecord
  belongs_to :item
  has_many :sub_options, dependent: :destroy

  accepts_nested_attributes_for :sub_options, allow_destroy: true

  validates :name, :name_en, presence: true
  validates :name, :name_en, uniqueness: { scope: :item_id }
  validates :maximum_choose, presence: true, numericality: { greater_than: 0 }, if: proc { |s| s.need_to_choose? }
end
