class ChangeSuspendedFromUsersToPromoters < ActiveRecord::Migration
  def up
    remove_column :users, :suspended
    add_column :promoters, :suspended, :boolean, :default=> false, :after => :updated_at
  end

  def down
    add_column :users, :suspended, :boolean, :default=> false, :after => :updated_at
    remove_column :promoters, :suspended
  end
end
