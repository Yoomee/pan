class AddDatesToTour < ActiveRecord::Migration
  def change
    add_column :tours, :start_on, :date, :after => :description
    add_column :tours, :end_on, :date, :after => :description
  end
end
