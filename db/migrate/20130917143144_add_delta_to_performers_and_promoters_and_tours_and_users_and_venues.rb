class AddDeltaToPerformersAndPromotersAndToursAndUsersAndVenues < ActiveRecord::Migration
  def change
    add_column :performers, :delta, :boolean, :default => true
    add_column :promoters, :delta, :boolean, :default => true
    add_column :tours, :delta, :boolean, :default => true
    add_column :users, :delta, :boolean, :default => true
    add_column :venues, :delta, :boolean, :default => true
    add_column :groups, :delta, :boolean, :default => true
    add_column :resources, :delta, :boolean, :default => true
  end
end
