module Mutations
  class CreateTweetMutation < GraphQL::Schema::Mutation 
    argument :content, String, required: true
    argument :handle, String, required: true

    field :success, Boolean, null: false, description: "This indicates if the mutation was resolved successfully"
    field :tweet, Types::TweetType, null: true
    field :errors, [String], null: false

    def resolve(args)
      user = User.find_by(handle: args[:handle])
      tweet = Tweet.new(content: args[:content], user: user)
      # tweet = Tweet.new(args)

      success = tweet.save
      errors = tweet.errors.full_messages 
      {
        success: success,
        errors: errors,
        tweet: success ? tweet : nil
      }
    end

  end
end
