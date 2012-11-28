class CreateCollectionsTours < ActiveRecord::Migration
def change
    create_table :collections_tours, :id => false do |t|
      t.integer :collection_id
      t.integer :tour_id
    end
    add_index :collections_tours, [:collection_id, :tour_id]
  end

end
