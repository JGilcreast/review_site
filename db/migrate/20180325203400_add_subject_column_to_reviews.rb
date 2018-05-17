class AddSubjectColumnToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :subject, :string
  end
end
