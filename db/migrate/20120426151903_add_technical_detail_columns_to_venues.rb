class AddTechnicalDetailColumnsToVenues < ActiveRecord::Migration

  def change
    change_table :venues do |t|
      t.integer :size
      t.integer :height
      t.integer :num_seats_min
      t.integer :num_seats_max
      t.integer :num_seats_tiered
      t.boolean :tiered_seating
      t.integer :stage_depth
      t.integer :stage_width
      t.boolean :stage_curtaining
      t.text :no_stage_text
      t.boolean :full_blackout
      t.boolean :curtains
      t.boolean :high_windows
      t.boolean :pa_system
      t.boolean :stereo_sound
      t.boolean :sound_technician
      t.boolean :lighting
      t.boolean :light_stand
      t.boolean :light_rigging
      t.boolean :light_washes
      t.boolean :light_spots
      t.boolean :light_dimmer
      t.boolean :light_technician
      t.text :equipment_installation
      t.boolean :piano
      t.boolean :piano_in_tune
      t.text :piano_text
      t.boolean :dressing_room
      t.boolean :kitchen
      t.boolean :bar
      t.boolean :loop_system
      t.boolean :wheelchair_accessible
      t.integer :num_steps
      t.integer :door_width
      t.text :accessibility_text
      t.boolean :help_for_entering
      t.boolean :help_for_exiting
      t.boolean :lorry_parking
      t.boolean :prs_licence
      t.boolean :alcohol_licence
      t.boolean :theatre_licence
      t.boolean :temporary_licence
      t.boolean :outdoor_licence
      t.boolean :public_entertainment_licence
      t.text :licence_text
    end
  end
  
end
