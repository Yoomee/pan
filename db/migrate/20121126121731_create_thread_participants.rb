class CreateThreadParticipants < ActiveRecord::Migration
  def change
    create_table :thread_participants do |t|
      t.references :message_thread
      t.integer :participant_id

      t.timestamps
    end
    add_index :thread_participants, :message_thread_id
    add_index :thread_participants, :participant_id
  end
end
