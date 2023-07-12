Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope 'api' do
    resources :represents
    resources :gk_settings
    get 'cell/:cellId', to: 'lts#get_quantity_by_cell_id'
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
