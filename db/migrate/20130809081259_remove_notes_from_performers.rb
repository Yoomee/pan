class RemoveNotesFromPerformers < ActiveRecord::Migration
  def up
    remove_column :performers, :notes
  end

  def down
    add_column :performers, :notes, :string
  end
end
