class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :restaurant_id, :items_count

  def items_count
    object.items.count
  end
end
