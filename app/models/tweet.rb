class Tweet < ApplicationRecord
  validates :content, length: { minimum: 3, maximum: 280 }
  belongs_to :user
  has_many :likes
  has_many :user_likes, through: :users, source: :user

  scope :tweet_by_word, ->(word) { where("content LIKE ?", "%#{word}%") }

  def self.find_tweet_by_word(word)
    tweet_by_word(word)
  end

  def self.tweet_order
    order("created_at DESC")
  end
  
  def self.unique_tweet
    select(:id, :user_id).select(:content).distinct
  end

  def self.tweet_per_user
    group(:user_id).count 
  end

  # def self.with_tweets
  #   joins(:users).select("users.*, COUNT(tweets.id)").group(:handle).having("COUNT(tweets.id) >= 1")
  # end
end

