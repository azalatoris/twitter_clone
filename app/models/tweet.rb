class Tweet < ApplicationRecord
  validates :content, length: { minimum: 3, maximum: 280 }
  belongs_to :user
  has_many :likes
  has_many :user_likes, through: :users, source: :user
end

