class AddPromoterIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :promoter_id, :integer
    add_index :users, :promoter_id
  end
end
