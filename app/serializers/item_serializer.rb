class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :category_id
end
