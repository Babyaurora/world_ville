class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :content
      t.integer :creator_id, null: false
      t.integer :owner_id, null: false
      t.integer :reply_id
      t.integer :rating, default: 0
      t.integer :reply_num, default: 0

      t.timestamps
    end
    add_index :stories, [:creator_id, :created_at]
    add_index :stories, [:owner_id, :created_at]
  end
end
