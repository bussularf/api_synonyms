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
    end
  end

  path '/api/v1/words/create_synonym_and_word' do
    parameter name: 'reference', in: :query, type: :string, description: 'word'
    parameter name: 'synonym', in: :query, type: :string, description: 'synonym'

    post('create_synonym_and_word') do
      response(201, 'successful') do
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
  end

  path '/users/sign_in' do
    post 'Signs in a user' do
      tags 'Sessions'
      parameter name: 'user[username]', in: :query, type: :string, description: 'username'
      parameter name: 'user[password]', in: :query, type: :string, description: 'password'

      response '200', 'user signed in' do
        let(:user) { { 'user[username]' => 'admin', 'user[password]' => '$dm!nhola123' } }


        before do
          post '/users/sign_in', params: user
        end

        run_test!
      end

      response '401', 'invalid login credentials' do
        let(:user) { { 'user[username]' => 'nicole', 'user[password]' => 'xxxxxx' } }
        run_test!
      end
    end
  end

  path '/api/v1/words/get_unreviewed_synonyms' do
    get('get_unreviewed_synonyms word') do
      response(200, 'successful') do
        before do
          # Use os headers de autenticação ao fazer a solicitação
          get '/api/v1/words/get_unreviewed_synonyms', headers: headers
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
    end
  end

  path '/api/v1/words/authorize_synonym' do
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
    end
  end

  path '/api/v1/words/delete_synonym' do
    parameter name: 'reference', in: :query, type: :string, description: 'word'
    parameter name: 'synonym', in: :query, type: :string, description: 'synonym'

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
    end
  end
end
