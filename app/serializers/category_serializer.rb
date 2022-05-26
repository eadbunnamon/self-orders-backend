class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :restaurant_id
end
