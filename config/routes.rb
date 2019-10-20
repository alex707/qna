Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voteable do
    member do
      post :vote
    end
  end

  resources :questions, concerns: %i[voteable] do
    resources :answers, only: %i[new create update destroy], shallow: true,
                        concerns: %i[voteable] do
      member do
        post :favour
      end
    end
  end

  resources :collections, only: :destroy

  resources :awards, only: :index
end
