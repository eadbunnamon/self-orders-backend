class SubOption < ApplicationRecord
  belongs_to :option

  validates :name, :name_en, presence: true
  # validates :name, :name_en, uniqueness: { scope: :option_id }
end
