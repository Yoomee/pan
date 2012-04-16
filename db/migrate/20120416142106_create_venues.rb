class CreateVenues < ActiveRecord::Migration

  def change
    create_table :venues do |t|
      t.belongs_to :promoter
      t.string :name
      t.text :description
      t.string :image_uid
      t.timestamps
    end
  end

end
