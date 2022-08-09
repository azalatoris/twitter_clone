require 'rails_helper'

RSpec.describe Mutations::CreateTweetMutation do 
  subject(:result) { TwitterSchema.execute(query, variables: variables).to_h }

  let(:user) { User.create(name: "Algirdas", handle: "azalatoris", "email": "az@a.com") }
  let(:query) { <<~GRAPHQL }
    mutation($content: String!, $handle: String!) {
      createTweet(content: $content, handle: $handle) {
        success
        errors
        tweet { content user { handle } }
      }
    }
  GRAPHQL

  context "with correct params" do
    let(:variables) { {content: "Hey there!", handle: user.handle} }

    it "creates a tweet" do
      expect { result }.to change(Tweet, :count).by(1)
    end

    it "returns correct data" do
      expect(result).to eq({
        "data" => {
          "createTweet" => {
            "success" => true,
            "errors" => [],
            "tweet" => {
              "content" => "Hey there!",
              "user" => {
                "handle" => "azalatoris"
              }
            }
          }
        }
      })
    end
  end
end