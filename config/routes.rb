Rails.application.routes.draw do
  resources :users, only: [:index, :show]
  resources :teams, only: [:index, :show]
  resources :stocks, only: [:index, :show]
  # get 'teams/index'
  # get 'teams/show'
  # get 'stocks/index'
  # get 'stocks/show'
  # get 'users/index'
  # get 'users/show'
  root 'users#index'
  
  resources :withdraws, only: [:new, :create]
  resources :deposits, only: [:new, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
