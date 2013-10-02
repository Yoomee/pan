class CreatePerformerUsers < ActiveRecord::Migration
  def change
    create_table :performer_users do |t|
      t.references :performer
      t.references :user

      t.timestamps
    end
    add_index :performer_users, :performer_id
    add_index :performer_users, :user_id
  end
end
