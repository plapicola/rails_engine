Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show', as: :find
        get '/find_all', to: 'search#index', as: :find_all
        get '/revenue', to: 'revenue#index', as: :revenue
        get '/most_revenue', to: 'most_revenue#index', as: :most_revenue
        get '/most_items', to: 'most_items#index', as: :most_items
        get '/random', to: 'random#show', as: :random
      end

      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchants/items#index', as: :items
        get '/invoices', to: 'merchants/invoices#index', as: :invoices
        get '/revenue', to: 'merchants/revenue#show', as: :revenue
        get '/favorite_customer', to: 'merchants/customers#show', as: :favorite_customer
        get '/customers_with_pending_invoices', to: 'merchants/customers#index', as: :pending_customers
      end

      namespace :items do
        get '/find', to: 'search#show', as: :find
        get '/find_all', to: 'search#index', as: :find_all
        get '/random', to: 'random#show', as: :random
        get '/most_revenue', to: 'most_revenue#index', as: :most_revenue
        get '/most_items', to: 'most_items#index', as: :most_items
      end

      resources :items, only: [:index, :show] do
        get '/invoice_items', to: 'items/invoice_items#index', as: :invoice_items
        get '/merchant', to: 'items/merchants#show', as: :merchant
      end
    end
  end
end
