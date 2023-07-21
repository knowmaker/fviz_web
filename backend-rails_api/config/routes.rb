Rails.application.routes.draw do
  get 'users/show'
  get 'users/create'
  get 'users/update'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope 'api' do
    resources :represents
    resources :gk_settings, only: [:index, :update]
    resources :quantities
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
