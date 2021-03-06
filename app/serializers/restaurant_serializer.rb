class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :open_time, :close_time,
  :day_off_description, :day_off_description_en, :active,
  :restaurant_type, :number_of_tables, :number_of_categories

  def restaurant_type
    ::RestaurantTypeSerializer.new(object.restaurant_type).attributes || {}
  end

  def number_of_tables
    return 0 if object.tables.blank?
    object.tables.count
  end

  def number_of_categories
    return 0 if object.categories.blank?
    object.categories.count
  end
end
