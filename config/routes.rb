Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'about' => 'homes#about'

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get 'quit_confirm'

    end
  end

  resources :posts
  get '/map_request', to: 'posts#map', as: 'map_request'
end
