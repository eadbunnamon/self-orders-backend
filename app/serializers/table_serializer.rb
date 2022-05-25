class TableSerializer < ActiveModel::Serializer
  attributes :id, :name, :qrcode, :restaurant_id
end
