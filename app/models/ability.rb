class Ability
  include CanCan::Ability
  
  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :manage, Event, :user_id => user.id
    end
  end
end