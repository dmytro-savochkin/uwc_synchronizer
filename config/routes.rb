Uwcplus::Application.routes.draw do
  match '/auth/:provider/callback', to: 'auth_callbacks#callback'




  get 'register' => 'users#new'
  get 'signin' => 'sessions#new'
  get 'signout' => 'sessions#destroy'

  resources :sessions, :only => %w(new create destroy)
  resources :users, :except => %w(index)

  match 'sync' => 'sync#index'
  root :to => 'sync#index'
end
