require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/words', type: :request do

  path '/api/v1' do
    get('list words') do
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
        let(:word_and_synonym) { { reference: 'foo', synonym: 'bar' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:word_and_synonym) {  { reference: 'foo', synonym: 'bar' } }

        run_test!
      end
    end
  end

  path '/api/v1/words/get_unreviewed_synonyms' do
    let(:current_owner) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: current_owner.id) }
  
    context 'when unauthorized' do
      before { get '/api/v1/words/get_unreviewed_synonyms' }
  
      it { expect(response).to have_http_status(:unauthorized) }
    end
  
    get('get_unreviewed_synonyms word') do
      response(200, 'successful') do
        before do
          allow_any_instance_of(Api::V1::AuthenticationController).to receive(:custom_authenticate).and_return(current_owner)
          get '/api/v1/words/get_unreviewed_synonyms', headers: { 'Authorization' => "Bearer #{token}" }
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
    let(:current_owner) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: current_owner.id) }

    context 'when unauthorized' do
      before { get api_v1_backoffice_words_path }

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
    let(:current_owner) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: current_owner.id) }

    context 'when unauthorized' do
      before { get api_v1_backoffice_words_path }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    parameter name: 'reference', in: :query, type: :string, description: 'word'
    parameter name: 'synonym', in: :query, type: :string, description: 'synonym'
    let!(:words) { example 'good' }

    delete('delete_synonym word') do
      response(200, 'successful') do
        let(:reference) { '123' }

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
        'Unable to delete synonym'
        run_test!
      end
    end
  end
end
