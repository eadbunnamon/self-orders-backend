class RestaurantTypeSerializer < ActiveModel::Serializer
  attributes :id, :type_name, :type_name_en, :description, :description_en, :active
end
