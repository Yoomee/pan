class AddTourRatingsToReviews < ActiveRecord::Migration

  def change
    add_column :reviews, :get_in_rating, :integer
    add_column :reviews, :after_show_rating, :integer
    add_column :reviews, :technical_rating, :integer
    add_column :reviews, :pre_show_rating, :integer
    add_column :reviews, :audience_rating, :integer
  end

end
