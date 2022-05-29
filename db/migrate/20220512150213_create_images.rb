class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images, id: :uuid do |t|
      t.string      :imageable_type
      t.uuid        :imageable_id
      t.string      :file

      t.timestamps
    end
  end
end
