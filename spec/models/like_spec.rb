require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "uniqueness validations" do
    context 'when user and tweet are present'
    let(:user) { User.create(name: "Algirdas", handle: "azalatoris", bio: "I am a coder", email: "az@a.cm" ) }
    let(:tweet) { Tweet.create(content: "I am coding today") }
    let(:like) { Like.create(user_id: user.id, tweet_id: tweet.id) }

    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:tweet_id) }

    context 'checks the instance of a like' do
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
    
        # specify do
        #   Like.create(user: user, tweet: tweet)
        #   expect(Like.find_by(user: user, tweet: tweet)).to be_a(Like)
        # end
      end
    end
  end
end

# Make the same test and instead of like/create, using a request spec