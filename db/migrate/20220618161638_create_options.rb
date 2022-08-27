class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.integer         :item_id
      t.string          :name
      t.string          :name_en
      t.boolean         :need_to_choose, default: true
      t.integer         :minimum_choose
      t.integer         :maximum_choose

      t.timestamps
    end
  end
end
