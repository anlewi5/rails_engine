Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show]
      resources :invoices,  only: [:index, :show]
      namespace :invoices do
        get '/find_all', to: 'search#index'
        get '/find',     to: 'search#show'
      end
    end
  end
end
