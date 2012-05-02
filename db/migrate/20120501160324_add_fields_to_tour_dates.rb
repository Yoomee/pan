class AddFieldsToTourDates < ActiveRecord::Migration
  def change
    add_column :tour_dates, :external_venue_name, :string, :after => :date
    add_column :tour_dates, :booked, :boolean, :default => false, :after => :date
  end
end
