Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope 'api' do
    resources :represents
    resources :gk_settings
    post 'cell', to: 'lts#get_quantity_by_cell_id'
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
