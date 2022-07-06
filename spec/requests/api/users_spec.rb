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

    let(:user) { User.create(name: "Al", handle: "capone", bio: "Gangster") }

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
  end
end