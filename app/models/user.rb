class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 6, maximum: 32 },
  format: { with: /\A[a-zA-Z\s]+\z/ }

  validates :handle, presence: true, length: { minimum: 4, maximum: 18 }, 
  format: { with: /\A[a-zA-Z0-9_.-]+\z/ }, uniqueness: { case_sensitive: false }

  validates :bio, length: { minimum: 4, maximum: 255 }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, 
  uniqueness: { case_sensitive: false }

  has_many :tweets
  has_many :likes
  has_many :liked_tweets, through: :likes, source: :tweet
end
