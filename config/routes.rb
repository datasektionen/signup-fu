Rails.application.routes.draw do
  resource :account, :controller => "users"
  
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
  
  resources :users
  resource :user_session
  
  match "login", :to => "user_sessions#new"
  
  match "/", :to => "events#index", :as => 'root'
end
