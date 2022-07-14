RSpec.describe 'API Tweets', type: :request do
  describe 'GET /api/tweets' do
    subject(:api_response) do
      get '/api/tweets'
      response
    end

    let!(:user) { User.create(name: "Algirdas", handle: "azalatoris", email: "az@gmail.com", bio: "Coder") }
    let!(:tweet) { Tweet.create(content: "What a sunny day!", user_id: user.id) }

    it { is_expected.to have_http_status(200) }

    specify do
      expect(JSON.parse(api_response.body)).to eq([{
        "id" => tweet.id,
        "content" => "What a sunny day!",
        "user_id" => user.id,
        "created_at" => tweet.created_at.to_i,
        "updated_at" => tweet.updated_at.to_i
      }])
    end

  end

  describe 'GET /api/tweets/:id' do
    subject(:api_response) do
      get "/api/tweets/#{tweet.id}"
      response
    end
    
    context 'when tweet exists' do

      it { is_expected.to have_http_status(200) }

      let(:user) { User.create(name: "Algirdas", handle: "azalatoris", email: "az@gmail.com", bio: "Coder") }
      let(:tweet) { Tweet.create(content: "What a sunny day!", user_id: user.id) }
      let!(:like) { Like.create(tweet: tweet, user: user) }

      it 'return tweet' do
        expect(JSON.parse(api_response.body)).to eq({
          "id" => tweet.id,
          "content" => "What a sunny day!",
          "user_id" => user.id,
          "created_at" => tweet.created_at.to_i,
          "updated_at" => tweet.updated_at.to_i,
          "likes" => [{
            "id" => like.id,
            "user_id" => user.id,
            "tweet_id" => tweet.id,
            "created_at" => like.created_at.to_i,
            "updated_at" => like.updated_at.to_i
          }],
          "user" => {
            "id" => user.id,
            "name" => user.name,
            "handle" => user.handle,
            "bio" => user.bio,
            "email" => user.email,
            "created_at" => user.created_at.to_i,
            "updated_at" => user.updated_at.to_i
          }
        })
      end

    end
  end

  describe 'POST /api/tweets/' do
    subject(:api_response) do
      post "/api/tweets", params: tweet_params
      response
    end

    context "creating a tweet with correct params" do
      let(:user) { User.create!(name: "Algirdas", handle: "azalatoris", bio: "bio", email: "r@r.co") }
      let(:tweet_params) { {content: "This is it", user_id: user.id} }

      it { is_expected.to have_http_status(201) }

      it do
        expect(JSON.parse(api_response.body)).to include(tweet_params.stringify_keys)
      end

      it { expect {api_response}.to change(Tweet, :count).by(1) }
    end

    context "creating a tweet with incorrect params" do
      let(:user) { User.create!(name: "Algirdas", handle: "azalatoris", bio: "bio", email: "r@r.co") }
      let(:tweet_params) { {content: "looks like a decent tweet but...", user_id: "some_id"} }

      it { is_expected.to have_http_status(422) }
    end
  end

  describe "PATCH /api/tweets/:id" do
    subject(:api_response) do
      patch "/api/tweets/#{tweet.id}", params: {content: "I updated this lousy tweet"}
    end

    let!(:user) { User.create(name: "Metallica", handle: "metallica", bio: "thrashers", email: "m@o.com") }
    let!(:tweet) { Tweet.create(content: "Hello World!", user_id: user.id) }

    context "updating the existing tweet" do
      it "updates the user's tweet" do
        expect { api_response }.to change { tweet.reload.content }.from("Hello World!").to("I updated this lousy tweet")
      end
    end
  end

  describe "DELETE /api/tweets/:id" do
    subject(:api_response) do
      delete "/api/tweets/#{tweet.id}"
      response
    end

    let!(:user) { User.create(name: "Metallica", handle: "metallica", bio: "thrashers", email: "m@o.com") }
    let!(:tweet) { Tweet.create(content: "Hello World!", user_id: user.id) }

    specify { expect(api_response).to have_http_status(200) }

    specify do
      expect(JSON.parse(api_response.body)).to include({
        "content" => "Hello World!",
        "user_id" => user.id
      })
    end

    specify do
      api_response
      expect { Tweet.find(tweet.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    specify { expect {api_response}.to change(Tweet, :count).by(-1) }
  end
end

# specify { expect {api_response}.to change(User, :count).by(-1) }
# end