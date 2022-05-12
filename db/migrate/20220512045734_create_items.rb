class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items, id: :uuid do |t|
      t.string            :name
      t.string            :name_en
      t.decimal           :price
      t.text              :description
      t.text              :description_en
      t.uuid              :category_id
      t.boolean           :active, default: true

      t.timestamps
    end
  end
end
