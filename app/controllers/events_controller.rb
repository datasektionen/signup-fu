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
end
