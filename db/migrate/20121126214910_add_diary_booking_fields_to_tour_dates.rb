class AddDiaryBookingFieldsToTourDates < ActiveRecord::Migration
  def change
    add_column :tour_dates, :time, :string, :after => :date
    add_column :tour_dates, :needs_approval, :boolean, :default => 0, :after => :booked
    add_column :tour_dates, :user_id, :int
  end
end
