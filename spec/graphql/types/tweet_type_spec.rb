require 'rails_helper'

RSpec.describe Types::TweetType do
  subject(:result) { TwitterSchema.execute(query, variables: variables).to_h }

  let(:query) { <<~GRAPHQL }
    query($id: ID!) {
      tweet(id: $id) {
        id 
        content
        createdAt
        updatedAt
      }
    }
  GRAPHQL

  let(:variables) { {id: tweet.id} }
  let!(:user) { User.create!(name: "Algirdas", handle: "azalatoris", email: "j@j.com") }
  let!(:tweet) { Tweet.create!(content: "Johnny B Goode", user: user) }

  it "returns correct data" do
    expect(result).to eq({
      "data" => {
        "tweet" => {
          "id" => tweet.id.to_s,
          "content" => tweet.content,
          "createdAt" => tweet.created_at.to_i,
          "updatedAt" => tweet.updated_at.to_i,
        }
      }
    })
  end
end