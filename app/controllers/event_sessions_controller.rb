class EventSessionsController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => :destroy
  skip_before_filter :require_user
  before_filter :load_event
  
  def new
    @event_session = EventSession.new
  end
  
  def create
    login_params = {
      :auth_name => @event.auth_name,
      :password => params[:event_session][:password]
    }
    @event_session = EventSession.new(login_params)

    if @event_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default event_path(@event)
    else
      render :action => :new
    end
  end
  
  def destroy
    current_event_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default '/'
  end
  
  private
  def load_event
    @event = Event.find(params[:event_id])
  end
end