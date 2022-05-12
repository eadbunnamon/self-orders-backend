class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :tables, id: :uuid do |t|
      t.string            :name
      t.uuid              :restaurant_id
      t.datetime          :last_generate_qr_code_at

      t.timestamps
    end
  end
end
