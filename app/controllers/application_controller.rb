# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  #filter_resource_access

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :logged_in?
  
  private
  def logged_in?
    !(current_user.nil? && current_event.nil?)
  end
  def current_user_session
    if @current_user_session.nil?
      @current_user_session = UserSession.find
    else
      @current_user_session
    end
  end

  def current_user
    if @current_user.nil?
      @current_user = current_user_session && current_user_session.user
    else
      @current_user
    end
  end
  
  def require_user
    unless current_user
      store_location
      render "errors/access_denied", :layout => true, :status => :forbidden
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def require_event_session_or_user
    if !current_user && (!current_event || current_event != @event)
      store_location
      flash[:error] = "Please log in to this event"
      redirect_to new_event_event_session_path(@event)
      return false
    end
  end
  
  
  def current_event_session
    if @current_event_session.nil?
      @current_event_session = EventSession.find
    else
      @current_event_session
    end
  end

  def current_event
    if @current_event.nil?
      @current_event = current_event_session && current_event_session.event
    else
      @current_event
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  protected
end
