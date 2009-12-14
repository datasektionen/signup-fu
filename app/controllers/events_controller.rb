class EventsController < ApplicationController
  def index
    @events = Event.all
  end
  
  def show
    @event = Event.find(params[:id])
  end
  
  def new
    @event = Event.new
    @event.mail_templates.build
    
    3.times { @event.ticket_types.build }
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    @event = Event.find(params[:id])
    
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
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to(events_path)
  end
  
  def dismiss_getting_started
    @event = Event.find(params[:id])
    @event.getting_started_dismissed = true
    @event.save!
    redirect_to(:action => 'show')
  end
  
  private
end
