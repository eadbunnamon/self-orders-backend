class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants, id: :uuid do |t|
      t.string            :name
      t.string            :name_en
      t.string            :open_time
      t.string            :close_time
      t.string            :day_off_description
      t.string            :day_off_description_en
      t.boolean           :open, default: false
      t.boolean           :active, default: false

      t.timestamps
    end
  end
end
