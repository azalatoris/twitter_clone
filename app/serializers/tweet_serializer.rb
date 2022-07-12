class TweetSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id

  belongs_to :user
  has_many :likes

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end