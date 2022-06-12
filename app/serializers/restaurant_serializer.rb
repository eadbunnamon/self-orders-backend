class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :open_time, :close_time,
  :day_off_description, :day_off_description_en, :active,
  :restaurant_type

  def restaurant_type
    ::RestaurantTypeSerializer.new(object.restaurant_type).attributes || {}
  end
end
