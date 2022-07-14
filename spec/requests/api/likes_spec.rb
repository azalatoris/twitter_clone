RSpec.describe "API Likes", type: :request do
  
  describe "POST /api/likes" do
    subject(:api_response) do
      post "/api/likes", params: like_params
      response
    end

    context "creating a like with right params" do
      let(:user) { User.create(name: "Algirdas", handle: "azalatoris", bio: "Coder", email: "e@o.com") }
      let(:tweet) { Tweet.create(content: "This is a new tweet", user_id: user.id) }
      let(:like_params) { {user_id: user.id, tweet_id: tweet.id} }

      it { is_expected.to have_http_status(201) }

      it do
        expect(JSON.parse(api_response.body)).to include(like_params.stringify_keys)
      end

      it { expect {api_response}.to change(Like, :count).by(1) }
    end

    context "creating a like with incorrect params" do
      let(:user) { User.create(name: "Algirdas", handle: "azalatoris", bio: "Coder", email: "e@o.com") }
      let(:tweet) { Tweet.create(content: "This is a new tweet", user_id: user.id) }
      let(:like_params) { {user_id: "some_id", tweet_id: tweet.id} }

      it { is_expected.to have_http_status(422) }

      it { expect {api_response}.to change(Like, :count).by(0) }
    end
  end

  describe "DELETE /api/likes/:id" do
    subject(:api_response) do
      delete "/api/likes/#{like.id}"
      response
    end

    let!(:user) { User.create(name: "Metallica", handle: "metallica", bio: "thrashers", email: "m@o.com") }
    let!(:tweet) { Tweet.create(content: "Hello World!", user_id: user.id) }
    let!(:like) { Like.create(user_id: user.id, tweet_id: tweet.id) }

    it { is_expected.to have_http_status(200) }

    specify do
      api_response
      expect { Like.find(like.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    specify { expect {api_response}.to change(Like, :count).by(-1)}
  end
end