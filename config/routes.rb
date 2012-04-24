ActionController::Routing::Routes.draw do |map|
  map.resources :permissions
  map.resources :roles
  map.resources :locations
  map.resources :members, :collection => [:edit_self], :has_many => :emails
  map.resources :accounts, :collection => {:list => :get, :unpaid => :get, :unpaid_print => :get, :events => :get}

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  map.connect "calendar/generate.:format", :controller => "events", :action => "generate"
  map.connect "calendar", :controller => "events", :action => "calendar";

  map.connect "mobile", :controller => "events", :action => "mobile";
  map.connect "iphone", :controller => "events", :action => "iphone";
  map.connect "i", :controller => "events", :action => "iphone";

  map.resources :organizations
  map.resources :bugs
  map.resources :tshirts
  map.resources :timecard_entries, :except => ['show']
	map.resources :timecards, :member => {:view => :get }
  map.resources :events,
                :member => [:delete_conf, :mobile_email],
                :collection => [:calendar, :iphone, :mobile, :lost]

  map.resources :attachments, :only => ["index", "destroy"]

  map.resources :emails, :has_many => [:email_assignments, :email_responses]

  map.resources :email_queues, :has_many => :emails

  map.resources :phonecalls

  map.connect "login", :controller => "useraccount", :action => "login"
  map.connect "logout", :controller => "useraccount", :action => "logout"

  map.connect '',   :controller => "events", :action => "index" 

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
