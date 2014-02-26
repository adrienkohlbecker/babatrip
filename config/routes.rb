 class OnlyAjaxRequest
  def matches?(request)
    request.xhr?
  end
end

TravelMeet::Application.routes.draw do

  def routes

    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:sessions, :registrations, :password]
    devise_scope :user do
      delete '/users/sign_out' => 'devise/sessions#destroy', :as => "destroy_user_session"
    end

    # Fix devise redirecting to sign in page instead of home on error during sign in
    get '/' => 'home#index', :as => "new_user_session"
    get '/about' => 'home#about', :as => "about"
    get '/terms' => 'home#terms', :as => 'terms'
    get '/privacy' => 'home#privacy', :as => 'privacy'

    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    root 'home#index'

    get 'me' => 'me#show', :as => 'my_profile'
    get 'me/edit' => 'me#edit', :as => 'edit_profile'
    put 'me/edit' => 'me#update'

    get '/search' => 'search#index'
    post '/search' => 'search#create'

    post '/trips' => 'trips#create'

    get '/trips/:id/image.png' => 'trips#image'

    get '/trips/:id/contact' => 'trips#contact_show', :constraints => OnlyAjaxRequest.new
    post '/trips/:id/contact' => 'trips#contact_create', :as => 'contact_trip', :constraints => OnlyAjaxRequest.new

    get '/trips/:id/edit' => 'trips#edit', :as => 'edit_trip', :constraints => OnlyAjaxRequest.new
    post '/trips/:id/edit' => 'trips#update', :as => 'update_trip', :constraints => OnlyAjaxRequest.new
    delete '/trips/:id' => 'trips#delete', :as => 'delete_trip', :constraints => OnlyAjaxRequest.new

    get '/users/:id_or_username' => 'users#show', :as => 'user_show', :constraints => {id_or_username: /[a-zA-Z0-9\.]+/}
    get '/users/:id_or_username/contact' => 'users#contact_show', :constraints => {id_or_username: /[a-zA-Z0-9\.]+/}
    post '/users/:id_or_username/contact' => 'users#contact_create', :as => 'contact_user', :constraints => {id_or_username: /[a-zA-Z0-9\.]+/}

  end

  if ENV['BETA_ONLY'] == '1'
    constraints subdomain: ['', 'www'] do
      get '/' => 'home#landing_page', :as => "landing_page"
    end
    constraints subdomain: 'beta' do
      routes
    end
  else
    constraints subdomain: 'beta' do
      get "(*x)" => redirect { |params, request|
        URI.parse(request.url).tap { |x| x.host = x.host.sub('beta', 'www') }.to_s
      }
    end
    routes
  end

end
