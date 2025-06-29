Rails.application.routes.draw do
  resources :texts, only: [:index] do
    collection do
      get 'admin', to: 'texts#admin'
      post 'admin', to: 'texts#create'
    end
  end
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
