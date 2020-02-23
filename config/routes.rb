require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'
  post :vote, to: 'votes#vote'

  resources :comments, only: %i[create]

  resources :questions do
    resources :answers, only: %i[new create update destroy], shallow: true do
      member do
        post :favour
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:show, :create, :update, :destroy],
                            shallow: true
      end
    end
  end

  resources :collections, only: :destroy

  resources :awards, only: :index

  post 'subscriptions/subscribe'
  post 'subscriptions/unsubscribe'

  mount ActionCable.server => '/cable'
end
