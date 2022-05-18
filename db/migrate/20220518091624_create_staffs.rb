class CreateStaffs < ActiveRecord::Migration[7.0]
  def change
    create_table :staffs, id: :uuid do |t|
      t.string      :name
      t.string      :phone_number
      t.string      :email
      t.uuid        :restaurant_id
      t.uuid        :role_id

      t.timestamps
    end

    add_index :staffs, :restaurant_id
    add_index :staffs, :role_id
  end
end
