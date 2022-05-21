class CreateRestaurantTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurant_types, id: :uuid do |t|
      t.string              :type_name
      t.string              :type_name_en
      t.text                :description
      t.text                :description_en
      t.boolean             :active, default: false
      t.string              :restaurant_type

      t.timestamps
    end
  end
end
