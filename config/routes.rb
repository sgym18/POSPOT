Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :sessions => "users/sessions"
  }

  root to: 'homes#top'

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  get 'about' => 'homes#about'

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get 'quit_confirm'
      patch 'quit'
    end
    resource :relationships, only: [:create, :destroy]
  end

  resources :posts do
    resource :bookmarks, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  get 'map_request' => 'posts#map', as: 'map_request'
  get 'search' => 'searches#search'
end
