class Setting < ApplicationRecord
  validates :currency, presence: true
  validates :vat, presence: true
end
