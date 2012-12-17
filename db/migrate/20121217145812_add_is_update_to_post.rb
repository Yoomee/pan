class AddIsUpdateToPost < ActiveRecord::Migration
  def change
    add_column :posts, :is_update, :boolean, :default => false
  end
end
