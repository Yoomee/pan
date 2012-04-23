class CreateTourDates < ActiveRecord::Migration

  def change
    create_table :tour_dates do |t|
      t.belongs_to :tour
      t.belongs_to :venue
      t.date :date
      t.timestamps
    end
    add_index :tour_dates, :tour_id
    add_index :tour_dates, :venue_id
  end
  
end
