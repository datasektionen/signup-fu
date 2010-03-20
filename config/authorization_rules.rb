authorization do
  role :admin do
    has_permission_on :events, :to => :manage
    has_permission_on :event_replies, :to => :manage
    has_permission_on :authorization_rules, :to => :read
  end
  
  role :user do
    has_permission_on :events, :to => :index
  end
  
  role :guest do
    has_permission_on :events, :to => [:new, :create]
    has_permission_on :event_replies, :to => [:new, :create, :show, :index]
  end
end

privileges do
  privilege :manage do
    includes :create, :new, :read, :update, :index, :show, :edit
  end
end