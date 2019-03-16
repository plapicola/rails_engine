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

      namespace :customers do
        get '/find', to: 'search#show', as: :find
        get '/find_all', to: 'search#index', as: :find_all
        get '/random', to: 'random#show', as: :random
      end

      resources :customers, only: [:index, :show] do
        get '/invoices', to: 'customers/invoices#index', as: :invoices
        get '/transactions', to: 'customers/transactions#index', as: :transactions
        get '/favorite_merchant', to: 'customers/merchants#show', as: :favorite_merchant
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
        get '/best_day', to: 'items/best_day#show', as: :best_day
      end

      namespace :invoices do
        get '/find', to: 'search#show', as: :find
        get '/find_all', to: 'search#index', as: :find_all
        get '/random', to: 'random#show', as: :random
      end

      resources :invoices, only: [:index, :show] do
        get '/customer', to: 'invoices/customers#show', as: :customer
        get '/merchant', to: 'invoices/merchants#show', as: :merchant
        get '/invoice_items', to: 'invoices/invoice_items#index', as: :invoice_items
        get '/items', to: 'invoices/items#index', as: :items
        get '/transactions', to: 'invoices/transactions#index', as: :transactions
      end

      namespace :invoice_items do
        get '/find', to: 'search#show', as: :find
        get '/find_all', to: 'search#index', as: :find_all
        get '/random', to: 'random#show', as: :random
      end

      resources :invoice_items, only: [:index, :show] do
        get '/item', to: 'invoice_items/items#show', as: :item
        get '/invoice', to: 'invoice_items/invoices#show', as: :invoice
      end
    end
  end
end
