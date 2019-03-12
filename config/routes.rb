Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants/search#show', as: :find_merchant
      resources :merchants, only: [:index, :show]
    end
  end
end
