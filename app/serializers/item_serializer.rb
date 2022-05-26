class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :price, :category_id
end
