ComplexresponseTells::Application.routes.draw do
  resources :tells

  get 'home/index'

  root :to => 'home#index'

  match 'last(.:format)' => 'home#last'
end
