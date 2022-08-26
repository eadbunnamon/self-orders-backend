class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string            :name
      t.string            :name_en
      t.text              :description
      t.text              :description_en
      t.integer           :category_id
      t.boolean           :active, default: true
      t.decimal           :price

      t.timestamps
    end
  end
end
