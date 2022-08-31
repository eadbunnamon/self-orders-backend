class Option < ApplicationRecord
  belongs_to :item
  has_many :sub_options, dependent: :destroy

  accepts_nested_attributes_for :sub_options, allow_destroy: true
  # validates_associated :sub_options

  validates :name, :name_en, presence: true
  # validates :name, :name_en, uniqueness: { scope: :item_id }
  validates :minimum_choose, presence: true, numericality: { greater_than: 0 }, if: proc { |s| s.need_to_choose? }
  validates :minimum_choose, presence: true, numericality: { equal_to: 0 }, if: proc { |s| !s.need_to_choose? }
  validates :maximum_choose, numericality: { greater_than: 0 }, if: proc { |s| s.maximum_choose.present? }

  validate :minimum_must_be_less_than_maximum

  private

  def minimum_must_be_less_than_maximum
    return if maximum_choose.blank?
    errors.add(:base, 'เลือกขั้นต่ำต้องน้อยกว่าหรือเท่ากับเลือกได้มากสุด') if maximum_choose.to_i < minimum_choose.to_i
  end
end
