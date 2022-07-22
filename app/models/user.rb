class User < ApplicationRecord
  validates_uniqueness_of :handle, uniqueness: { case_sensitive: false }
  validates_uniqueness_of :email, uniqueness: { case_sensitive: false }
  
  validates :name, presence: true, length: { maximum: 32 },
  format: { with: /\A[a-zA-Z\s]+\z/ }

  validates :handle, presence: true, length: { minimum: 4, maximum: 18 }, 
  format: { with: /\A[a-zA-Z0-9_.-]+\z/ }

  validates :bio, length: { maximum: 255 }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :tweets
  has_many :likes
  has_many :liked_tweets, through: :likes, source: :tweet

  scope :with_empty_bio, -> { where("bio = ''") }
  scope :has_in_bio, ->(word) { where("bio LIKE ?", "%#{word}") }
  scope :name_start, ->(prefix) { where("name LIKE ?", "#{prefix}%") }
  scope :name_ends, ->(postfix) { where("name LIKE ?", "%#{postfix}") } 
  scope :with_handle, ->(handle) { where("handle LIKE ?", "#{handle}") }
  scope :extensive, ->(handle, excerpt) { where(handle: handle).and(where("bio LIKE '%#{excerpt}%'")) }
  scope :handle_and_bio, -> { select("handle, bio") }

  def self.first_tweet
    joins(:tweets).select("users.*, MAX(tweets.id)")
  end

  def self.last_tweet
    joins(:tweets).select("users.*, MIN(tweets.id)")
  end

  def self.with_tweets
    joins(:tweets).select("users.*, COUNT(tweets.id)").order("COUNT(tweets.id) desc").group(:id).having("COUNT(tweets.id) >= 1")
  end

  def self.max_tweets
    joins(:tweets).select("users.*, COUNT(tweets.id)").order("COUNT(tweets.id) desc").group(:id).limit(1)
  end

  def self.min_tweets
    joins(:tweets).select("users.*, COUNT(tweets.id)").order("COUNT(tweets.id)").group(:handle).limit(1)
  end

  def self.name_starts_with(prefix)
    name_start(prefix)
  end

  def self.name_ends_with(postfix)
    name_ends(postfix)
  end

  def self.find_handle(handle)
    with_handle(handle)
  end

  def self.find_in_bio(word)
    has_in_bio(word)
  end

  def self.extensive_search(handle, excerpt)
    extensive(handle, excerpt)
  end

  def self.handle_bio
    handle_and_bio
  end

  def self.list_tweets(user)
    find(user).tweets
  end

  def self.limited(limit)
    limit(limit)
  end

  def self.bio_empty
    with_empty_bio
  end

  def self.join_tweets
    joins(:tweets)
  end
end



=begin

1. Replace User with self, play with both methods
2. Removing the self altogether
3. Then removing all

1. Implementing more queries
=end