class AddDetailsToTours < ActiveRecord::Migration
  def change
    add_column :tours, :additional_events, :text, :after => :description
    add_column :tours, :expiry_date, :date, :after => :start_on
  end
end
