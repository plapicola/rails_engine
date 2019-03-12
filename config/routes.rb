Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show', as: :find
        get '/find_all', to: 'search#index', as: :find_all
      end
      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchants/items#index', as: :merchant_items
        get '/invoices', to: 'merchants/invoices#index', as: :merchant_invoices
      end
    end
  end
end
