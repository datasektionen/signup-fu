class User < ActiveRecord::Base
  #acts_as_authentic
  
  def role_symbols
    if admin?
      [:user, :admin]
    else
      [:user]
    end
  end
end
