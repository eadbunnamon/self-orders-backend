class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :category_id, :options

  has_many :options

  def options
    object.options.map do |option|
      ::OptionSerializer.new(option).attributes
    end
  end
end
