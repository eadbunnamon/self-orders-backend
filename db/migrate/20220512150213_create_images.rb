class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images, id: :uuid do |t|
      t.references  :imageable, polymorphic: true
      t.string      :file

      t.timestamps
    end
  end
end
