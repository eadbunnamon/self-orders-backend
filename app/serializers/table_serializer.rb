class TableSerializer < ActiveModel::Serializer
  attributes :id, :name, :restaurant_id, :last_generate_qr_code_at, :qrcode
end
