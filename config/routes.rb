Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post 'api/v1/auth/login', to: 'api/authentication#login'

  match '*unmatched_route', to: 'application#route_not_found', via: :all

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      root to: 'words#index'
      resources :words, except: :index do
        collection do
          post 'create_synonym_and_word'
          get 'get_unreviewed_synonyms'
          put 'authorize_synonym'
          delete 'delete_synonym'
        end
      end
    end
  end
end
