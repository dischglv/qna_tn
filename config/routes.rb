Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  concern :votable do
    member do
      patch :vote_for
      patch :vote_against
      delete :cancel_vote
    end
  end

  resources :questions, concerns: [ :votable ], except: :edit do
    resources :comments, only: :create

    resources :answers, concerns: [ :votable ], only: %i[show create update destroy] do
      resources :comments, only: :create

      member do
        patch :best
      end
    end
  end

  resources :awards, only: :index
  resources :files, only: :destroy
  resources :links, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
