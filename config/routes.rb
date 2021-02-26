Rails.application.routes.draw do
  devise_for :users

  resources :questions, except: :edit do
    resources :answers, only: %i[show create update destroy] do
      member do
        patch :best
      end
    end
  end

  resources :awards, only: :index
  resources :files, only: :destroy
  resources :links, only: :destroy

  # delete 'files/:id', to: 'files#destroy', as: 'files'
  # delete 'links/:id', to: 'links#destroy', as: 'link'

  root to: 'questions#index'
end
