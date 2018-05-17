class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :review, :counter_cache => true

  paginates_per 10

  validates :user, :review, presence: true
  validates :content, presence: true, length: { minimum: 3 }

end
