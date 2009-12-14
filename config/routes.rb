ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  
  map.resources :events, :member => {:dismiss_getting_started => :post}, :shallow => true do |events|
    events.resource :event_session
    events.resources :mail_templates
    events.resources :event_replies, :as => 'replies',
      :collection => {
        :economy => [:get, :post],
        :set_attending => :post,
        :names => :get
      }
  end
  
  map.resources :users
  map.resource :user_session
  
  map.root :controller => 'home', :action => 'index'
end
