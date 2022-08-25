class CreateRolesUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :roles_users do |t|
      t.integer              :role_id, null: false
      t.integer              :user_id, null: false

      t.timestamps
    end
  end
end
