class AddPromoterToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :promoter_id, :int
  end
end
