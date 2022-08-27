class Option < ApplicationRecord
  belongs_to :item
  has_many :sub_options, dependent: :destroy

  accepts_nested_attributes_for :sub_options, allow_destroy: true

  validates :name, :name_en, presence: true
  validates :name, :name_en, uniqueness: { scope: :item_id }
  validates :minimum_choose, presence: true, numericality: { greater_than: 0 }, if: proc { |s| s.need_to_choose? }

  before_validation :update_minimum_choose, if: proc { |s| !s.need_to_choose? }

  private

  def update_minimum_choose
    self.minimum_choose = 0
  end
end
