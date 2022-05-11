class CreateRolesUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :roles_users, id: :uuid do |t|
      t.uuid              :role_id, null: false
      t.uuid              :user_id, null: false

      t.timestamps
    end
  end
end
