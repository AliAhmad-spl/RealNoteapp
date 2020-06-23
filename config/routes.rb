Rails.application.routes.draw do
  resources :notes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
end
