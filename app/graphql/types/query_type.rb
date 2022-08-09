module Types
  class QueryType < GraphQL::Schema::Object
    field :working, Boolean, null: false
    field :tweets, [Types::TweetType], null: false
    field :users, [Types::UserType], null: false
    field :likes, [Types::LikeType], null: false
    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end
    field :tweet, Types::TweetType, null: false do 
      argument :id, ID, required: true
    end
    field :like, Types::LikeType, null: false do
      argument :id, ID, required: true
    end

    def working
      true
    end

    def users
      User.all
    end

    def tweets
      Tweet.all
    end

    def likes
      Like.all
    end

    def user(args)
      User.find(args[:id])
    end

    def tweet(args)
      Tweet.find(args[:id])
    end

    def like(args)
      Like.find(args[:id])
    end
  end
end