Rails.application.routes.draw do
  devise_for :users

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
