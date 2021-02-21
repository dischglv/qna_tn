Rails.application.routes.draw do
  devise_for :users

  resources :questions, except: :edit do
    resources :answers, only: %i[show create update destroy] do
      member do
        patch :best
      end
    end
  end

  delete 'files/:id', to: 'files#destroy', as: 'files'

  root to: 'questions#index'
end
