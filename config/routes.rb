# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  mount Travelingo::APIBase => '/api'

  # ADMIN AUTHENTICATION
  namespace :admin do
    get :sign_in, to: 'sessions#new'
    post :sign_in, to: 'sessions#create'
    get :sign_out, to: 'sessions#destroy'
  end

  root to: 'admin/sessions#new'
end
