Travel::Application.routes.draw do
  
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
  resources :trips
  resources :trip_activities
  resources :trips do
    member do
      get 'showpartial'
    end
    resources :trip_activities do
      member do
        get 'mapinfo'
        get 'carddeck'
        get 'showpartial'
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
  unless Rails.application.config.consider_all_requests_local
      match '*not_found', to: 'errors#error_404'
  end
end
