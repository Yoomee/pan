class CreateTours < ActiveRecord::Migration

  def change
    create_table :tours do |t|
      t.belongs_to :company
      t.string :name
      t.text :description
      t.string :image_uid
      t.text :requirements
      t.string :target_age
      t.string :running_time
      t.string :publicity
      t.string :fees
      t.integer :min_playing_area
      t.boolean :blackout_needed, :default => false
      t.boolean :uses_lighting, :default => false
      t.boolean :uses_own_lighting, :default => false
      t.boolean :uses_sound, :default => false
      t.boolean :suits_arts_venue, :default => false
      t.boolean :suits_village_hall, :default => false
      t.boolean :suits_school_hall, :default => false
      t.boolean :suits_outdoors, :default => false
      t.timestamps
    end
  end

end
