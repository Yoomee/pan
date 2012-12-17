class CreateLikes < ActiveRecord::Migration
  
  def change
    create_table :likes do |t|
      t.belongs_to :resource, :polymorphic => true
      t.belongs_to :user
      t.timestamps
    end
    add_index :likes, [:resource_type, :resource_id]
    add_index :likes, :user_id
  end
  
end