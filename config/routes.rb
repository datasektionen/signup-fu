Rails.application.routes.draw do
  devise_for :users

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
  
  match "/", :to => "home#index", :as => 'root'
end
