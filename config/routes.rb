Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, only: %i[new create update destroy], shallow: true do
      member do
        post :favour
      end

      delete :remove_file
    end
  end

  resources :collections, only: :destroy
end
