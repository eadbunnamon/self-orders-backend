class SubOptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :name_en, :additional_price,
  :created_at, :updated_at
end
