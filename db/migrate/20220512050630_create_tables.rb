class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :tables do |t|
      t.string            :name
      t.integer           :restaurant_id
      t.text              :qrcode
      t.datetime          :last_generate_qr_code_at

      t.timestamps
    end
  end
end
