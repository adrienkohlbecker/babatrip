 class OnlyAjaxRequest
  def matches?(request)
    request.xhr?
  end
end

Babatrip::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:sessions, :registrations, :password]
  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy', :as => "destroy_user_session"
  end

  # Fix devise redirecting to sign in page instead of home on error during sign in
  get '/' => 'home#index', :as => "new_user_session"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Admin interface
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get 'me' => 'me#show'
  get 'me/edit' => 'me#edit'
  put 'me/edit' => 'me#update'

  get '/search' => 'search#index'
  post '/search' => 'search#create'

  get '/trips/:id/popin' => 'trips#popin', :constraints => OnlyAjaxRequest.new
  post '/trips/:id/contact' => 'trips#contact', :as => 'contact_trip'

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
