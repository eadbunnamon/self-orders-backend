class OptionSerializer < ActiveModel::Serializer
  attributes :id, :size, :price, :is_default
end
