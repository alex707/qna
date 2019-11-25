Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  post :vote, to: 'votes#vote'
  post :vote, to: 'comments#comment'

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
