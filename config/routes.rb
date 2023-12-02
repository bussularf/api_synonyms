Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post '/auth/login', to: 'authentication#login'
      root to: 'words#index'
      resources :words, except: :index do
        collection do
          post 'create_synonym_and_word'
          get 'unreviewed_synonyms'
          put 'authorize_synonym'
          delete 'delete_synonym'
        end
      end
    end
  end
end
