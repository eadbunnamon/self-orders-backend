class CreateSubOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_options do |t|
      t.integer           :option_id
      t.string            :name
      t.string            :name_en
      t.decimal           :additional_price, default: 0

      t.timestamps
    end
  end
end
