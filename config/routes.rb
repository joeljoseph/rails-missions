Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do 
    resources 'fibonaccis', controller: 'fibonaccis', only: [:index, :create], defaults: { format: 'json' }
  end

end
