require 'rails_helper'

RSpec.describe Types::UserType do
  subject(:result) { TwitterSchema.execute(query, variables: variables).to_h }

  let(:query) { <<~GRAPHQL }
    query($id: ID!) {
      user(id: $id) {
        id
        name
        handle
        email
        createdAt
        updatedAt
        tweets { id }
      }
    }
  GRAPHQL

  let(:variables) do 
    return {id: user.id} 
  end

  let(:user) { User.create(name: "Algirdsa", handle: "azalatori", email: "t@e.co") }
  let!(:tweet) { Tweet.create(content: "Hello there", user: user) }

  it "returns correct data" do
    expect(result).to eq({
      "data" => {
        "user" => {
          "id" => user.id.to_s,
          "name" => user.name,
          "handle" => user.handle,
          "email" => user.email,
          "createdAt" => user.created_at.to_i,
          "updatedAt" => user.updated_at.to_i,
          "tweets" => [{ "id" => tweet.id.to_s }]
        }
      }
    })
  end
end