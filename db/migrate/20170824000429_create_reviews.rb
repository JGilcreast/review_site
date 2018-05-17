class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.string :media
      t.string :genre
      t.string :content
      t.integer :rating
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
