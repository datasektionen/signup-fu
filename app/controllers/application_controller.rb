# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authenticate_user!
  
  def permission_denied 
    flash[:error] = "Sorry, you not allowed to access that page."
    if current_user.nil?
      redirect_to login_path
    else
      render :text => "Access denied", :layout => true
    end
  end
  # permission_denied must be public, since declarative_authorization does
  # respond_to?...
  hide_action :permission_denied
  
  def logged_in?
    true
  end
  helper_method :logged_in?
  
  private

  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
