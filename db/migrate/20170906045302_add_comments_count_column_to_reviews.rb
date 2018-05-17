class AddCommentsCountColumnToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :comments_count, :integer
  end
end
