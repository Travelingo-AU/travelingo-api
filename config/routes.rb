# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  mount Travelingo::APIBase => '/api'

  root to: "home#index"
end
