class RemoveAdditionalEventsFromTours < ActiveRecord::Migration
  def up
    remove_column :tours, :additional_events
  end

  def down
    add_column :tours, :additional_events, :string
  end
end
