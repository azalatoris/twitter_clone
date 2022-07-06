RSpec.describe 'API Users', type: :request do
  describe 'GET /api/users' do
    subject(:api_response) do
      get '/api/users'
      response
    end

    let!(:user) { User.create(name: "Algirdas", handle: "azalatoris", email: "az@a.com", bio: "I am a coder") }

    specify { expect(api_response).to have_http_status(200) }
    specify do 
      expect(JSON.parse(api_response.body)).to eq([{
      "id" => user.id,
      "name" => user.name,
      "handle" => user.handle,
      "bio" => user.bio,
      "created_at" => user.created_at.to_i,
      "updated_at" => user.updated_at.to_i
    }])
    end
  end

  describe 'GET /api/users/:id' do
    subject(:api_response) do
      get "/api/users/#{user.id}"
      response
    end

    let(:user) { User.create!(name: "Al Capone", handle: "capone", bio: "Gangster", email: "az@a.com") }

    specify { expect(api_response).to have_http_status(200) }
    specify do
      expect(JSON.parse(api_response.body)).to eq({
        "id" => user.id,
        "name" => user.name,
        "handle" => user.handle,
        "bio" => user.bio,
        "created_at" => user.created_at.to_i,
        "updated_at" => user.updated_at.to_i,
        "tweets" => []
      })
    end

    context 'when user has some tweets' do
      let!(:tweet) { Tweet.create(content: "Hey", user: user) }

      specify do
        expect(JSON.parse(api_response.body)).to eq({
          "id" => user.id,
          "name" => user.name,
          "handle" => user.handle,
          "bio" => user.bio,
          "created_at" => user.created_at.to_i,
          "updated_at" => user.updated_at.to_i,
          "tweets" => [{
            "id" => tweet.id,
            "content" => tweet.content,
            "user_id" => tweet.user_id
          }]
        })
      end
    end

    context "when user not found" do
      subject(:api_response) do
        get '/api/users/not_existing_id'
        response
      end

      specify { expect(api_response).to have_http_status(404) }
      specify { expect(JSON.parse(api_response.body)).to eq({"errors" => "Couldn't find User with 'id'=not_existing_id"}) }
    end
  end

  describe 'POST /api/users' do
    subject(:api_response) do
      post '/api/users', params: params
      response
    end

    let(:params) { {name: "Tony Hawk", handle: "thawk", bio: "Pro Skater"} }

    specify { expect(api_response).to have_http_status(201) }
    specify do
      expect(JSON.parse(api_response.body)).to include({
        "name" => params[:name],
        "handle" => params[:handle],
        "bio" => params[:bio]
      })
    end
    specify { expect { api_response }.to change(User, :count).by(1) }
  end
end