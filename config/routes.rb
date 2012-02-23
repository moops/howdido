Howdido::Application.routes.draw do
  root :to => "races#index"
  resources :participations
  resources :user_sessions
  resources :results
  resources :races
  match 'races/:id/load' => 'results#load', :as => :load_results
  resources :users
end
