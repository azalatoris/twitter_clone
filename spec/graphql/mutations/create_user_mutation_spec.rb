require 'rails_helper'

RSpec.describe Mutations::CreateUserMutation do
  subject(:result) { TwitterSchema.execute(query, variables: variables).to_h }

  let(:query) { <<~GRAPHQL }
    mutation($name: String!, $handle: String!, $email: String!) {
      createUser(name: $name, handle: $handle, email: $email) {
        success
        errors
        user { name handle email }
      }
    }
  GRAPHQL

  context 'with correct params' do
    let(:variables) { {name: "Robert", handle: "roberto", email: "ea@fasf.com"} }

    it "creates a user" do 
      expect { result }.to change(User, :count).by(1)
    end

    it "returns correct data" do 
      expect(result).to eq({
        "data" => {
          "createUser" => {
            "success" => true,
            "errors" => [],
            "user" => {
              "name" => "Robert",
              "handle" => "roberto",
              "email" => "ea@fasf.com"
            }
          }
        }
      })
    end
  end

  context 'with incorrect params' do

    let(:variables) { {name: "", handle: "roberto", email: "ea@fasf.com"} }
  
    it "doesn't creates a user" do 
      expect { result }.not_to change(User, :count)
    end

    it "returns correct data" do 
      expect(result).to eq({
        "data" => {
          "createUser" => {
            "success" => false,
            "errors" => ["Name can't be blank", "Name is invalid"],
            "user" => nil
          }
        }
      })
    end
  end
end