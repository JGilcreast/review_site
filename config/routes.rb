Rails.application.routes.draw do

  post '/reviews/:id' => "comments#create"
  delete '/reviews/:id/:comment_id' => "comments#destroy"

  get '/' => "reviews#home"
  get '/reviews' => "reviews#index"
  post '/reviews' => "reviews#create"
  get '/reviews/all' => "reviews#all"
  get '/reviews/new' => "reviews#new"
  get '/reviews/:id' => "reviews#show"
  patch '/reviews/:id' => "reviews#update"
  delete '/reviews/:id' => "reviews#destroy"
  get '/reviews/:id/edit' => "reviews#edit"
  post '/reviews/:id/edit' => "reviews#update"

  get '/users' => "users#index"
  get '/login' => "users#new"
  post '/users' => "users#create"
  get '/users/:id' => "users#show"
  patch '/users/:id' => "users#update"
  delete '/users/:id' => "users#destroy"


  post '/login' => "sessions#create"
  get '/logout' => "sessions#destroy"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
