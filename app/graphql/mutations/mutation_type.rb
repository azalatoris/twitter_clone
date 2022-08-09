module Mutations
  class MutationType < GraphQL::Schema::Object
    field :create_user, mutation: Mutations::CreateUserMutation
    field :create_tweet, mutation: Mutations::CreateTweetMutation
  end
end