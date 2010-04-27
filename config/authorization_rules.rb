authorization do
  role :admin do
    has_permission_on :events, :to => :manage
    has_permission_on :replies, :to => :manage
    has_permission_on :authorization_rules, :to => :read
    has_permission_on :users, :to => :manage
  end
  
  role :user do
    has_permission_on :events, :to => :index
    has_permission_on :events, :to => [:new, :create]
    has_permission_on :events, :to => :manage do
      if_attribute :owner => is { user }
    end
    has_permission_on :replies, :to => :manage do
      if_permitted_to :manage, :event
    end
  end
  
  role :guest do
    has_permission_on :events, :to => [:new, :create]
    has_permission_on :replies, :to => [:new, :create, :show, :index]
    has_permission_on :home, :to => [:index]
  end
end

privileges do
  privilege :manage do
    includes :create, :new, :read, :update, :index, :show, :edit, :destroy
  end
end