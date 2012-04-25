class RemoveResourceFromPosts < ActiveRecord::Migration
  
  def self.up
    remove_column :posts, :resource
  end
  
  def self.down
    add_column :posts, :resource, :boolean, :default => false
  end
  
end
