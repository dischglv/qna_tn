Rails.application.routes.draw do
  devise_for :users

  resources :questions, except: :edit do
    resources :answers, only: %i[show create update destroy]
  end

  root to: 'questions#index'
end
