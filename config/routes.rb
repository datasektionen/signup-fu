ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  
  map.resources :events, :member => {
      :dismiss_getting_started => :post,
      :reminder_run => :post,
      :expiry_run => :post
    }, :shallow => true do |events|
    events.resources :mail_templates
    events.resources :replies, :as => 'replies',
      :collection => {
        :economy => [:get, :post],
        :permit => :get,
        :set_attending => :post,
        :names => :get
      }
  end
  
  map.resources :users
  map.resource :user_session
  
  map.login "login", :controller => 'user_sessions', :action => 'new'
  
  map.root :controller => 'events', :action => 'index'
end
