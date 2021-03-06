Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # POST /api/robot/0/orders
  namespace :api do
  	resources :robot do
  		member do
  			post :orders
  		end
  	end
  end
end
