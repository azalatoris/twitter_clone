class Like < ApplicationRecord
  validates :user_id, presence: true
  validates :tweet_id, presence: true
  validates_uniqueness_of :user_id, scope: :tweet_id, message: "user liked this post already"

  belongs_to :user
  belongs_to :tweet
end
