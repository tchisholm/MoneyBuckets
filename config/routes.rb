ActionController::Routing::Routes.draw do |map|

  map.resources :users, :has_many => [ :accounts, :buckets ]
  
  map.resource :session, :controller => 'session'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.userinfo '/userinfo', :controller => 'users', :action => 'edit'
  map.login '/login', :controller => 'session', :action => 'new'
  map.logout '/logout', :controller => 'session', :action => 'destroy'

  map.resources :accounts, :has_many => [:abuckets, :recurrings, :transactions, :histories],
    :member => { :budget_report => :get, :transaction_detail_report => :get, 
      :archive_transactions_list => :get, :archive_transactions => :post,
      :view_archived_transactions => :get, :unarchive_transactions => :post, 
      :purge_archived_transactions => :get, :purge_transactions => :post }
  map.resources :abuckets, 
    :member => { :abucket_add => :post, :transaction_detail_report => :get }
  map.resources :recurrings, :has_many => [:rbuckets]
  map.resources :transactions, :has_many => [:tbuckets],
    :member => { :reconcile => :get, :unreconcile => :get }
  map.resources :histories, :has_many => [:hbuckets]
  map.resources :helppages
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id',
  #:controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'session', :action => 'new'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
