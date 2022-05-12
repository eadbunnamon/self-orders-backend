class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string              :name
      t.string              :name_en
      t.uuid                :restaurant_id
      t.boolean             :active, default: true

      t.timestamps
    end
  end
end
