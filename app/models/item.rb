class Item < ApplicationRecord
  belongs_to :category
  has_one :image, as: :imageable
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :image
  accepts_nested_attributes_for :options, allow_destroy: true

  validates :name, :name_en, presence: true

  def self.validate_options_data(options_attributes={})
    return [false, ['กรุณาระบุค่าเริ่มต้น']] if options_attributes.blank?

    options_attributes.reject! {|opt| opt['_destroy'].present?}

    valid = true
    error_messages = []
    defaults = options_attributes.pluck(:is_default)

    if defaults.select {|d| d.to_s == 'true'}.count > 1
      valid = false
      error_messages << 'ไม่สามารถระบุค่าเริ่มต้นได้มากกว่าหนึ่งรายการ'
    end

    if defaults.select {|d| d.to_s == 'true'}.count == 0
      valid = false
      error_messages << 'กรุณาระบุค่าเริ่มต้น'
    end

    return [valid, error_messages]
  end
end
