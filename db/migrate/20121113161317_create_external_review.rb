class CreateExternalReview < ActiveRecord::Migration
  def change
    create_table :external_reviews do |t|
      t.belongs_to :reviewable, :polymorphic => true
      t.text :review
      t.timestamps
    end
    add_index :external_reviews, [:reviewable_id, :reviewable_type]
  end
end
