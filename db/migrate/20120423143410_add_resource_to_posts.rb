class AddResourceToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :resource, :boolean, :default => false
  end
end
