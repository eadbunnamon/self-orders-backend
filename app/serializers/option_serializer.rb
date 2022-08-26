class OptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :need_to_choose, :maximum_choose,
  :created_at, :updated_at
end
