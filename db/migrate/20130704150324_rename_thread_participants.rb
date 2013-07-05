class RenameThreadParticipants < ActiveRecord::Migration
  def self.up
    remove_index :thread_participants, :participant_id
    remove_index :thread_participants,  :message_thread_id
    rename_table :thread_participants, :message_thread_users
  end
  def self.down
    rename_table :message_thread_users, :thread_participants
    add_index :thread_participants, :participant_id
    add_index :thread_participants,  :message_thread_id
  end
end
