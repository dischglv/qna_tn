Rails.application.routes.draw do
  get 'awards/index'
  get 'links/destroy'
  devise_for :users

  resources :questions, except: :edit do
    resources :answers, only: %i[show create update destroy] do
      member do
        patch :best
      end
    end
  end

  resource :awards, only: :index

  delete 'files/:id', to: 'files#destroy', as: 'files'
  delete 'links/:id', to: 'links#destroy', as: 'link'

  root to: 'questions#index'
end
