class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.integer         :item_id
      t.string          :size
      t.decimal         :price, default: 0
      t.boolean         :is_default, default: false

      t.timestamps
    end
  end
end
