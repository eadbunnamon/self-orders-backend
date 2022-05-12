class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings, id: :uuid do |t|
      t.string            :currency
      t.decimal           :vat
      t.decimal           :service_charge

      t.timestamps
    end
  end
end
