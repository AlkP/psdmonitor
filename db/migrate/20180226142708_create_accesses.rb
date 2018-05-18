class CreateAccesses < ActiveRecord::Migration[5.1]
  def change
    create_table :accesses do |t|
      t.integer :user_id, null: false,  limit: 5
      t.integer :role,    null: false,  limit: 2

      t.index ['user_id', 'role'], name: 'user_id_role_unique', unique: true
    end
  end
end
