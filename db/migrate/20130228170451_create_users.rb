class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :unique_id, null: false
      t.string :display_name, null: false
      t.string :email
      t.string :password_digest, null: false
      t.string :session_token, null: false
      t.integer :user_type, null: false
      t.integer :coins
      t.boolean :admin, default: false

      t.timestamps
    end
    add_index :users, :unique_id, unique: true
    add_index :users, :session_token
  end
end
