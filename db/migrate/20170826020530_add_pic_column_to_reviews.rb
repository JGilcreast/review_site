class AddPicColumnToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :pic_url, :string
  end
end
