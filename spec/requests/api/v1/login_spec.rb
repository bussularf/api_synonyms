require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'AuthenticationController', type: :request do
  let(:current_owner) { create(:user) }

  describe 'POST authentication#login' do
    path '/api/v1/auth/login' do
      post 'create token and user admin' do
        consumes 'application/json'
        produces 'application/json'
        tags :auth

        parameter name: :data, in: :body, schema: {
          type: :object,
          properties: {
            username: { type: :string },
            password: { type: :string, format: :password }
          },
          required: [
            :data
          ]
        }

        response '201', 'created' do
          let!(:data) do
            {
              username: current_owner.username,
              password: '$dm!nhola123'
            }
          end

          before do
            create(:user, data.merge(admin: true))
          end

          schema type: :object, properties: {
            token: { type: :string },
            expires: { type: :string },
            username: { type: :string }
          }

          run_test!
        end
      end
    end
  end
end
