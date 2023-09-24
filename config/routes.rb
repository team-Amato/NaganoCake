Rails.application.routes.draw do
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  #scope module: :public do
   # root to: "homes#top"
   # get '/about' => "homes#about"
   # get '/customers/mypage' => 'customers#show'
  #  get 'customers/check'
    #patch 'customers/withdraw'
  #end
  
  
    scope module: :public do
    root to: "homes#top"
    get '/about' => "homes#about"
    get '/customers/mypage' => 'customers#show'
    get 'customers/check'
    patch 'customers/withdraw'
    resources :cart_items, only: [:index, :update, :destroy, :create]
    delete 'cart_items/destroy_all'
    resources :orders, only: [:new, :create, :index, :show]
    post 'orders/confirm'
    get 'orders/thanks'
    resources :items, only: [:index, :show]
    resources :addresses, only: [:index, :edit, :create, :update, :destroy]
  end
  
  namespace :public do
  resources :customers, only: [:show, :edit, :update]
end

 # resources :cart_items, only: [:index, :update, :destroy, :create]
 # delete 'cart_items/destroy_all'

 # resources :orders, only: [:new, :create, :index, :show]
 # post 'orders/confirm'
  #get 'orders/thanks'

  resources :items, only: [:index, :show]

  resources :addresses, only: [:index, :edit, :create, :update, :destroy]

  #admin
  namespace :admin do
    get '/admin/sign_in' => 'sessions#new'
    post '/admin/sign_in' => 'sessions#create'
    delete '/admin/sign_out' => 'sessions#destroy'
  end

 # namespace :admin do
   # get '/admin' => 'homes#top'
  #end

  #namespace :admin do
    #resources :order_details, only: [:update]
    #resources :items, only: [:edit, :update, :new, :create, :index, :show]
    #resources :genres, only: [:edit, :update, :index, :create]
    #resources :customers, only: [:edit, :update, :index, :show]
    #resources :orders, only: [:show, :update]
  #end

namespace :admin do
    get '/' => 'homes#top'
    resources :order_details, only: [:update]
    resources :items, only: [:edit, :update, :new, :create, :index, :show]
    resources :genres, only: [:edit, :update, :index, :create]
    resources :customers, only: [:edit, :update, :index, :show]
    resources :orders, only: [:show, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end