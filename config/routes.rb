Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show', as: :find
        get '/find_all', to: 'search#index', as: :find_all
      end
      resources :merchants, only: [:index, :show]
    end
  end
end
