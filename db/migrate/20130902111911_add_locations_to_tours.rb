class AddLocationsToTours < ActiveRecord::Migration
  def change
    add_column :tours, :locations, :string, :after => :description
  end
end
