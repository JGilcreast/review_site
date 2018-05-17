class User < ActiveRecord::Base
  has_many :comments
  has_many :reviews
  has_secure_password validations: false

  paginates_per 12

  validates  :email, presence: {message: "Please enter an email address in a valid format such as example@email.com"}, format: { with: /\A^[^.@]+@[^.@]+\.[^.@]+$\z/, message: "Please enter an email address in a valid format such as example@email.com" }
  validates  :name, presence: {message: "Please enter a name for your account"}
  validates  :password, length: { minimum: 4, maximum: 72, message: "Please enter a password at least 4 characters long"}, confirmation: {message: "Password must match confirmation field"}, :if => :password_digest_changed?
  validates  :password_confirmation, presence: {message: "Please confirm your password"}, :if => :password_digest_changed?
  validates_uniqueness_of :email, message: 'That email address has already been taken'
  validates_uniqueness_of :name, message: 'That name has already been taken'
end
