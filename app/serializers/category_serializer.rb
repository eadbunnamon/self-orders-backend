class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :restaurant_id, :restaurant_name, :items_count

  def items_count
    object.items.count
  end

  def restaurant_name
    object&.restaurant&.name
  end
end
