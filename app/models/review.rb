class Review < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  paginates_per 10

  validates :user, presence: {message: 'You must be logged in to post a review'}
  validates :subject, presence: {message: 'Please enter what you are reviewing in the subject field'}
  validates :media, presence: true
  validates :genre, presence: true
  validates :content, presence: {message: 'A review must have content!'}, length: { minimum: 20, message: 'Reviews must be at least 20 characters long' }

end
