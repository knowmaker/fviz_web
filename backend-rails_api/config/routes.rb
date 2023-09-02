# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope 'api' do
    resources :represents, only: %i[index create update destroy]
    get '/active_view', to: 'represents#represent_view_index'
    get '/active_view/:id', to: 'represents#represent_view_show'
    get '/layers/:id', to: 'represents#lt_values'
    resources :gk_settings, only: %i[index update]
    resources :quantities
    resources :laws, only: %i[index show create update destroy]
    resources :law_types, only: %i[index show create update destroy]
    post '/signup', to: 'users#create'
    post '/login', to: 'users#login'
    get '/profile', to: 'users#show'
    patch '/update', to: 'users#update'
    post '/reset', to: 'users#reset'
    resources :users, only: [] do
      member do
        get :confirm, to: 'users#confirm'
      end
      get :new_password, on: :member
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
