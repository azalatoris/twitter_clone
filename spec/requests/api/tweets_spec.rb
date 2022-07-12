RSpec.describe 'API Tweets', type: :request do
  describe 'GET /api/tweets' do
    subject(:api_response) do
      get '/api/tweets'
      response
    end

    let!(:user) { User.create(name: "Algirdas", handle: "azalatoris", email: "az@gmail.com", bio: "Coder") }
    let!(:tweet) { Tweet.create(content: "What a sunny day!", user_id: user.id) }

    specify { expect(api_response).to have_http_status(200) }
    specify do
      expect(JSON.parse(api_response.body)).to eq([{
      "id" => tweet.id,
      "content" => "What a sunny day!",
      "user_id" => user.id,
      }])
    end

  end
end