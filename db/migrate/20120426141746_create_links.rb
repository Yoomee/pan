class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.belongs_to :attachable, :polymorphic => true
      t.text :url
      t.string :title
      t.string :host
      t.timestamps
    end
    add_index :links, [:attachable_id,:attachable_type]
  end
end
