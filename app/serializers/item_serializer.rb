class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :price, :category_id, :options, :image_url

  has_many :options

  def options
    object.options.map do |option|
      ::OptionSerializer.new(option).attributes
    end
  end

  def image_url
    return nil if object.image.blank?
    "#{image_domain}#{object.image&.file&.url}"
  end

  private

  def image_domain
    'http://localhost:4500'
  end
end
