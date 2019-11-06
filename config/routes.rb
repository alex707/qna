Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  post :vote, to: 'votes#vote'

  resources :questions do
    resources :answers, only: %i[new create update destroy], shallow: true do
      member do
        post :favour
      end
    end
  end

  resources :collections, only: :destroy

  resources :awards, only: :index
end
