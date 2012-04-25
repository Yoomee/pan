class CreateResources < ActiveRecord::Migration

  def change
    create_table :resources do |t|
      t.string :file_name
      t.text :file_intro
      t.string :file_uid
      t.string :image_uid
      t.belongs_to :user
      t.timestamps
    end
    add_index :resources, :user_id
  end

end
