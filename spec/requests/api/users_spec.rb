RSpec.describe 'API Users', type: :request do
  describe 'GET /api/users' do
    subject(:api_response) do
      get '/api/users'
      response
    end

    let!(:user) { User.create(name: "Algirdas", handle: "azalatoris", email: "az@a.com", bio: "I am a coder") }

    it { is_expected.to have_http_status(200) }

    context "when user exists" do
      specify do 
        expect(JSON.parse(api_response.body)).to eq([{
        "id" => user.id,
        "name" => user.name,
        "handle" => user.handle,
        "bio" => user.bio,
        "email" => user.email,
        "created_at" => user.created_at.to_i,
        "updated_at" => user.updated_at.to_i
      }])
      end
    end
  end

  describe 'GET /api/users/:id' do
    subject(:api_response) do
      get "/api/users/#{user.id}"
      response
    end
    
    let(:user) { User.create!(name: "Al Capone", handle: "capone", bio: "Gangster", email: "az@a.com") }

    context "when user has no tweets" do
    specify { expect(api_response).to have_http_status(200) }
      specify do
        expect(JSON.parse(api_response.body)).to eq({
          "id" => user.id,
          "name" => user.name,
          "handle" => user.handle,
          "bio" => user.bio,
          "email" => user.email,
          "created_at" => user.created_at.to_i,
          "updated_at" => user.updated_at.to_i,
          "tweets" => []
        })
      end
    end

    context 'when user has some tweets' do
      let!(:tweet) { Tweet.create(content: "Hey", user: user) }

      specify do
        expect(JSON.parse(api_response.body)).to eq({
          "id" => user.id,
          "name" => user.name,
          "handle" => user.handle,
          "bio" => user.bio,
          "email" => user.email,
          "created_at" => user.created_at.to_i,
          "updated_at" => user.updated_at.to_i,
          "tweets" => [{
            "id" => tweet.id,
            "content" => tweet.content,
            "user_id" => tweet.user_id,
            "created_at" => tweet.created_at.to_i,
            "updated_at" => tweet.updated_at.to_i,
          }]
        })
      end
    end

    context "when user doesn't exist" do
      subject(:api_response) do
        get '/api/users/bla'
        response
      end

      it { is_expected.to have_http_status(404) }
      specify { expect(JSON.parse(api_response.body)).to eq({"errors" => "Couldn't find User with 'id'=bla"}) }
    end
  end

  describe 'POST /api/users' do
    subject(:api_response) do
      post '/api/users', params: user_params
      response
    end

    context "when params are correct" do
      let(:user_params) { {name: "Tony Hawk", handle: "thawk", bio: "Pro Skater", email: "thawk@gmail.com"} }

      specify { expect(api_response).to have_http_status(201) }
      specify do
        expect(JSON.parse(api_response.body)).to include({
          "name" => user_params[:name],
          "handle" => user_params[:handle],
          "bio" => user_params[:bio],
          "email" => user_params[:email]
        }) 
      end

      specify { expect { api_response }.to change(User, :count).by(1) }
    end

    context 'when params are incorrect' do
      let(:user_params) { {name: ""} }

      specify { expect(api_response).to have_http_status(422) }
      specify { expect { api_response}.not_to change(User, :count) }
      specify do
        expect(JSON.parse(api_response.body)).to include(
          {
            "errors" => include(
              "Name can't be blank", 
              "Handle can't be blank"
            )
          }
        )
      end
    end
  end

  describe 'PATCH /api/users/:id' do     
    subject(:api_response) do
      patch "/api/users/#{user.id}", params: {handle: 't_hawk'}
      response
    end

    let(:user) { User.create!(name: "Tony Hawk", handle: "thawk", bio: "Pro Skater", email: "thawk@gmail.com") }

    context "updating the user field" do
      it "updates the user's field" do
        expect { api_response }.to change { user.reload.handle }.from("thawk").to("t_hawk")
      end
    end
  end
  
  describe 'DELETE /api/users/:id' do
    subject(:api_response) do
      delete "/api/users/#{user.id}"
      response
    end

    let!(:user) { User.create(name: "Algirdas", handle: "azalatoris", bio: "Coder", email: "z@g.ca") }

    specify { expect(api_response).to have_http_status(200) }

    specify do
      expect(JSON.parse(api_response.body)).to include({
        "name" => "Algirdas",
        "handle" => "azalatoris",
        "bio" => "Coder",
        "email" => "z@g.ca"
      })
    end

    specify do
      api_response
      expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound) 
    end

    specify { expect {api_response}.to change(User, :count).by(-1) }
  end
end

