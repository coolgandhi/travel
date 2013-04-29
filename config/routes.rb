Travel::Application.routes.draw do
  
  get "author_info/about_edit"
  put "author_info/about_update"

  devise_for :author_infos, :controllers => {:omniauth_callbacks => "omniauth_callbacks"}

  get "login" => "sessions#new"
  get "logout" => "sessions#del"
  match "sessions" => "sessions#create", :via => :post
  #resource :sessions 
  # do
  #   member do
  #     get "del"
  #   end
  # end

  get "venues/pick"
  get "venues/get_venue_info"
  get "venues/get_venue_photos"
  get "venues/get_venue_details"

  get "locations/pick"

  #get "location_detail/pick"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  
  %w[about privacy tos].each do |page|
    get page, :controller => "info", :action => page
  end
  
  #resources :trips
  resources :author_info do
    member do
      get 'author_page'
    end
  end  
  resources :trip_activities
  resources :trips do
    member do
      get 'showpartial'
      get 'daymapinfo'
      get 'publish_edit'
      get 'publish_confirm'
      get 'publish_add_day'
      get 'publish_delete_day'
      get 'publish_trip_partial_format'
      put 'publish_update'
      put 'update_individual'
      put 'publish_confirm_update'
    end
    collection do
      get 'trips_admin'
      get 'publish_new'
      post 'publish_create'
      post 'edit_individual'
    end
    resources :trip_activities do
      member do
        get 'mapinfo'
        get 'carddeck'
        get 'showpartial'
        get 'show_activity_photos'
        get 'publish_trip_activity_edit'
        put 'publish_trip_activity_update'
        post 'add_new_photo'
        delete 'publish_trip_activity_destroy'
      end
      collection do
        get 'move'
        get 'publish_trip_activity_new'
        post 'publish_trip_activity_create'
      end
    end
  end # I nested trip_activities into trips so that we can have routes with /trip/:trip_id/trip_activities/:id hkl
  
  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'trips#index', :featured => '1'
  resque_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end
  
  constraints resque_constraint do
    mount Resque::Server, :at => "/resque"
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
  unless Rails.application.config.consider_all_requests_local
     match '*not_found', :to => 'errors#error_404'
  end
end
