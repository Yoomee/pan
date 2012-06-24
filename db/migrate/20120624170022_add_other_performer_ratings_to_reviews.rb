class AddOtherPerformerRatingsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :rural_rating,:integer
    add_column :reviews, :small_venue_rating, :integer
    add_column :reviews, :relationship_rating, :integer
    add_column :reviews, :support_rating, :integer
    add_column :reviews, :value_rating, :integer
    add_column :reviews, :marketing_rating, :integer
    add_column :reviews, :workshop_rating, :integer
  end
end
