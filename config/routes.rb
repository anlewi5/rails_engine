Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      namespace :invoices do
        get '/find_all', to: 'search#index'
        get '/find',     to: 'search#show'
        get '/random',   to: 'search#show'
      end
      resources :invoices,  only: [:index, :show]

      namespace :merchants do
        get '/find_all', to: 'search#index'
        get '/find',     to: 'search#show'
        get '/random',   to: 'search#show'
      end
      resources :merchants, only: [:index, :show]

      resources :items,     only: [:index, :show]

      namespace :customers do
        get '/find_all', to: 'search#index'
        get '/find',     to: 'search#show'
        get '/random',   to: 'search#show'
      end
      resources :customers, only: [:index, :show]

      namespace :transactions do
        get '/find_all', to: 'search#index'
        get '/find',     to: 'search#show'
        get '/random',   to: 'search#show'
      end
      resources :transactions, only: [:index, :show]
    end
  end

end
