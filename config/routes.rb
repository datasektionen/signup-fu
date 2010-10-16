Rails.application.routes.draw do
  devise_for :users

  resource :account, :controller => "users"
  
  match "/e/:username/:event_name/new" => "replies#new", :as => 'public_new_reply'
  match "/e/:username/:event_name" => 'replies#create', :via => :post
  match "/e/:username/:event_name/tack" => "replies#thanks", :as => 'public_reply_created'
  match "/e/:username/:event_name" => "replies#index", :as => 'public_event'
  
  shallow do
    resources :events do
      member do
        post :dismiss_getting_started
        post :reminder_run
        post :expiry_run
      end
      
      resources :mail_templates
      
      resources :replies do
        collection do
          match :economy, :via => [:get, :post]
          get :permit
          post :set_attending
          get :names
        end
      end
    end
  end
  
  match "/", :to => "home#index", :as => 'root'
end
