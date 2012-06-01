class AddTargetToResources < ActiveRecord::Migration
  def change
    add_column :resources, :target_id, :integer, :after => :user_id
    add_column :resources, :target_type, :string, :after => :user_id
    add_index :resources, [:target_type,:target_id]
  end
end
