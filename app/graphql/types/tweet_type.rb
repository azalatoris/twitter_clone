module Types 
  class TweetType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :content, String, null: false
    field :created_at, Integer, null: false
    field :updated_at, Integer, null: false
    field :user, Types::UserType, null: false
  end

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
  # Add likes
end