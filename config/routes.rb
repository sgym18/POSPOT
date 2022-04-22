Rails.application.routes.draw do
  root to: 'homes#top'
  devise_for :users, skip: [:passwords], :controllers => {
    :sessions => "users/sessions"
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get 'quit_confirm'
      patch 'quit'
    end
    resource :relationships, only: [:create, :destroy]
  end

  namespace :admin do
    resources :users, only: [:index, :edit, :update]
  end

  resources :posts do
    resource :bookmarks, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  get 'about' => 'homes#about'
  get 'search' => 'searches#search'
end
