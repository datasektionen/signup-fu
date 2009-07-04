ActionController::Routing::Routes.draw do |map|
  map.resources :events, :shallow => true do |events|
    events.resources :mail_templates
    events.resources :event_replies, :as => 'replies', :collection => {:economy => [:get, :post]}
  end
  
  map.root :controller => 'events', :action => 'index'
end
