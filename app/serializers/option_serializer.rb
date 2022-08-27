class OptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :need_to_choose, :minimum_choose, :maximum_choose, :sub_options,
  :created_at, :updated_at

  has_many :sub_options

  def sub_options
    object.sub_options.map do |sub_option|
      ::SubOptionSerializer.new(sub_option).attributes
    end
  end
end
