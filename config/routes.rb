Rails.application.routes.draw do
  root to: 'rooms#index'

  resources :rooms, only: [:index, :create, :show] do
    resources :messages, only: :create
  end

  resources :users, only: [:new, :create, :destroy]
end
