Rails.application.routes.draw do
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

  resources :collections, only: :destroy

  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
