class AddRemovedAtToTourDates < ActiveRecord::Migration
  def change
    add_column :tour_dates, :removed_at, :datetime, :after => :updated_at
  end
end
