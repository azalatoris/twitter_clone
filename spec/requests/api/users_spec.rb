RSpec.describe 'API Users', type: :request do
  describe 'GET /api/users' do
    subject(:api_response) do
      get '/api/users'
      response
    end

    let!(:user) { User.create(name: "Algirdas", handle: "azalatoris", email: "az@a.com", bio: "alalala") }

    specify { expect(api_response).to have_http_status(200) }
    specify do 
      expect(JSON.parse(api_response.body)).to eq([{
      "id" => user.id,
      "name" => user.handle,
      "handle" => user.handle,
      "bio" => user.bio,
      "created_at" => user.created_at.to_i,
      "updated_at" => user.updated_at.to_i
    }])
    end
  end
end