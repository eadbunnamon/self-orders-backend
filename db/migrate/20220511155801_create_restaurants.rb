class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string            :name
      t.string            :name_en
      t.string            :open_time
      t.string            :close_time
      t.string            :day_off_description
      t.string            :day_off_description_en
      t.boolean           :open, default: false
      t.boolean           :active, default: true
      t.integer           :restaurant_type_id

      t.timestamps
    end
  end
end
