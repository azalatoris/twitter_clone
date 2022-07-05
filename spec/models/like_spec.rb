require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) do
    User.create(
      name: "Algirdas", handle: "azalatoris", 
      bio: "I am a coder", email: 'az@gmail.com') 
  end
  let(:tweet) do
    Tweet.create(
      content: "Good day!", user: user)
  end

  context 'creating a new like' do

    specify do
      Like.create(user: user, tweet: tweet)
      expect(Like.find_by(user: user, tweet: tweet)).to be_a(Like)
    end
  end
end

# Make the same test and instead of like/create, using a request spec