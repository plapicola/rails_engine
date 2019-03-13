Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show', as: :find
        get '/find_all', to: 'search#index', as: :find_all
        get '/revenue', to: 'revenue#index', as: :revenue
        get '/most_revenue', to: 'most_revenue#index', as: :most_revenue
        get '/most_items', to: 'most_items#index', as: :most_items
      end
      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchants/items#index', as: :items
        get '/invoices', to: 'merchants/invoices#index', as: :invoices
        get '/revenue', to: 'merchants/revenue#show', as: :revenue
        get '/favorite_customer', to: 'merchants/customers#show', as: :favorite_customer
      end
    end
  end
end
