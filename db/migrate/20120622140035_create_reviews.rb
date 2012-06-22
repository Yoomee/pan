class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.belongs_to :user
      t.belongs_to :performer
      t.belongs_to :tour
      t.string :title
      t.text :description
      t.integer :overall_rating
      
      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, :performer_id
    add_index :reviews, :tour_id
  end
end
