class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :content
      t.integer :user_id, null: false
      t.integer :to_user_id, null: false
      t.integer :reply_id
      t.integer :rating, default: 0
      t.integer :reply_num, default: 0

      t.timestamps
    end
    add_index :stories, [:to_user_id, :created_at]
  end
end
