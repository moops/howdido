Howdido::Application.routes.draw do
  resources :participations
  resources :user_sessions
  resources :results
  resources :races
  match 'races/:id/load' => 'results#load', :as => :load_results
  resources :users
  root :to => "races#index"
end
