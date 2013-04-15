class AddIdsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :house_id, :integer
    add_column :users, :founder_id, :integer
    add_column :users, :mayor_id, :integer
  end
end
