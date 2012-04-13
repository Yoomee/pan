class CreatePromoters < ActiveRecord::Migration

  def change
    create_table :promoters do |t|
      t.string :name
      t.text :description
      t.string :image_uid
      t.timestamps
    end
  end

end
