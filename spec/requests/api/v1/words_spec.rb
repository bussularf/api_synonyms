# rubocop:disable all
require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/words', type: :request do
  before do
    let(:current_owner) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: current_owner.id) }
  end

    describe 'GET /index' do
      path '/api/v1' do
        get('Get words') do
          consumes 'application/json'
          produces 'application/json'
          before do
            let!(:words) { create_list(:word, 5) }
          end

          response(200, 'successful') do
            after do |example|
              example.metadata[:response][:content] = {
                'application/json' => {
                  example: JSON.parse(response.body, symbolize_names: true)
                }
              }
            end
            run_test!
          end

          response(400, 'bad request') do
            'bad request'
            run_test!
          end
        end
      end
    end

    path '/api/v1/words/search_synonyms' do
      get('List search_synonyms') do
        description 'List synonyms'

        parameter name: 'reference', in: :query, type: :string, description: 'word'

        response(200, 'successful') do
          after do |example|
            example.metadata[:response][:content] = {
              'application/json' => {
                example: JSON.parse(response.body, symbolize_names: true)
              }
            }
          end

          run_test!
        end

        response(400, 'bad request') do
          'Unable to authorize synonym'
          run_test!
        end
      end
    end

  path '/api/v1/words/create_synonym_and_word' do
    parameter name: 'reference', in: :query, type: :string, description: 'word'
    parameter name: 'synonym', in: :query, type: :string, description: 'synonym'

    post('create_synonym_and_word') do
      after do |example|
        example.metadata[:response][:content] = {
          'application/json' => {
            example: JSON.parse(response.body, symbolize_names: true)
          }
        }
      end
      response '201', 'synonym and/or word created' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/words/unreviewed_synonyms' do
    get('unreviewed_synonyms word') do
      let(:authorization_header) { { 'Authorization' => "Bearer #{token}" } }

      before do
        header authorization_header
        allow_any_instance_of(Api::V1::AuthenticationController).to receive(:custom_authenticate).and_return(current_owner)
        get '/api/v1/words/unreviewed_synonyms'
      end
      response(200, 'successful') do
        it 'has Authorization header' do
          expect(authorization_header).to be_present
          binding.b
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
  
        run_test!
      end
  
      response(400, 'bad request') do
        'bad request'
        run_test!
      end
    end
  end
  

  path '/api/v1/words/authorize_synonym' do
    context 'when unauthorized' do
      before { get api_v1_words_path }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    parameter name: 'reference', in: :query, type: :string, description: 'word'
    parameter name: 'synonym', in: :query, type: :string, description: 'synonym'

    put('authorize_synonym word') do
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response(400, 'bad request') do
        'Unable to authorize synonym'
        run_test!
      end
    end
  end

  path '/api/v1/words/delete_synonym' do
    let(:Authorization) { "Bearer #{token}" }

    parameter name: 'reference', in: :query, type: :string, description: 'word'
    parameter name: 'synonym', in: :query, type: :string, description: 'synonym'

    delete('delete_synonym word') do
      response(200, 'successful') do
        run_test!
      end

      response(400, 'bad request') do
        'Unable to delete synonym'
        run_test!
      end
    end
  end
end
