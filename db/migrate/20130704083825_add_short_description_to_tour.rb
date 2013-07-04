class AddShortDescriptionToTour < ActiveRecord::Migration
  def change
    add_column :tours, :short_description, :text
  end
end
