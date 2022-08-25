class CreateRestaurantsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants_users do |t|
      t.integer          :restaurant_id
      t.integer          :user_id

      t.timestamps
    end

    add_index :restaurants_users, [:restaurant_id, :user_id], unique: true
  end
end
