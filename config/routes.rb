Uwcplus::Application.routes.draw do
  match '/auth/:provider/callback' => 'auth_callbacks#callback'
  match '/auth/failure' => 'auth_callbacks#failure'

  get 'register' => 'users#new'
  get 'signin' => 'sessions#new'
  get 'signout' => 'sessions#destroy'
  put 'update_preferred_cloud' => 'users#update_preferred_cloud'

  resources :sessions, :only => %w(new create destroy)
  resources :users, :except => %w(index)

  match 'sync' => 'sync/welcome#index'
  namespace :sync do
    match 'edit_avatar' => 'avatar#edit'
    match 'update_avatar' => 'avatar#update'
    match 'approve_avatar' => 'avatar#approve'

    match 'edit_profile' => 'profile#edit'
    match 'update_profile' => 'profile#update'



    match 'show_gists' => 'gist#show'
    match 'upload_gist' => 'gist#upload'
  end

  root :to => 'sync/welcome#index'
end
