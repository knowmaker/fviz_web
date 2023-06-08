Rails.application.routes.draw do
  get 'gk_settings/index'
  get 'gk_settings/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope 'api' do
    resources :represents
    resources :gk_settings
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
