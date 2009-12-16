class EventsController < ApplicationController
  before_filter :load_event, :require_event_session_or_user, :only => [:show, :edit, :update, :destroy, :dismiss_getting_started]
  skip_before_filter :require_user, :except => [:index]
  
  def index
    @events = Event.all
  end
  
  def show
  end
  
  def new
    @event = Event.new
    @event.mail_templates.build
    
    3.times { @event.ticket_types.build }
  end
  
  def edit
  end
  
  def update
    
    if @event.update_attributes(params[:event])
      flash[:notice] = "Event successfully updated"
      redirect_to @event
    else
      render :action => "edit"
    end
  end
  
  def create
    @event = Event.new(params[:event])
    
    if @event.save
      redirect_to(event_path(@event))
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @event.destroy
    redirect_to(events_path)
  end
  
  def dismiss_getting_started
    @event.getting_started_dismissed = true
    @event.save!
    redirect_to(:action => 'show')
  end
  
  private
  
  def load_event
    @event = Event.find(params[:id])
  end
end
