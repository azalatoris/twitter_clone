module Types
  class UserType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :name, String, null: false
    field :handle, String, null: false
    field :bio, String, null: true
    field :email, String, null: true
    field :created_at, Integer, null: false
    field :updated_at, Integer, null: false
    field :tweets, [Types::TweetType], null: false
  end

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end