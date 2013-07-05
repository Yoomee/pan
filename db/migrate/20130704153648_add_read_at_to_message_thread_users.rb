class AddReadAtToMessageThreadUsers < ActiveRecord::Migration
  def change
    add_column :message_thread_users, :read_at, :datetime
    add_column :message_thread_users, :read, :boolean, :default => false
    rename_column :message_thread_users, :participant_id, :user_id

    add_index  :message_thread_users,  :user_id
    add_index :message_thread_users, :message_thread_id
  end
end
