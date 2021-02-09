Rails.application.routes.draw do
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end


  resources :questions do
    resources :answers
  end

  root to: 'questions#index'
end
