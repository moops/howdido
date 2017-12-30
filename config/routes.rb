Rails.application.routes.draw do
  devise_for :users
  root to: 'races#index'
  resources :participations
  resources :results
  resources :races do
    resources :results
  end
  resources :users
  post 'races/:id/load' => 'results#load', as: :load_results
end
