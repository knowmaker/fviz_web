# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope 'api' do
    resources :represents, only: %i[index create update destroy]
    get '/active_view', to: 'represents#represent_view_index'
    get '/active_view/:id', to: 'represents#represent_view_show'
    get '/layers/:id', to: 'quantities#lt_values'
    resources :gk, only: %i[index show update]
    resources :lt, only: %i[index]
    resources :quantities
    resources :laws, only: %i[index show create update destroy] do
      post :check, on: :collection
    end
    resources :law_types, only: %i[index show create update destroy]
    resources :users do
      post :register, on: :collection
      post :login, on: :collection
      get :profile, on: :collection
      patch :update, on: :collection
      delete :destroy, on: :collection
      post :reset, on: :collection
      get :confirm, on: :member
      get :new_password, on: :member
    end
  end
end
