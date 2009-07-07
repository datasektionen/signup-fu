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
    remove_unselected_mail_template_attributes
    
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
  
  private
  def remove_unselected_mail_template_attributes
    params[:event][:mail_templates_attributes].each do |id, template_attributes|
      unless params[template_attributes[:name]]
        params[:event][:mail_templates_attributes].delete(id)
      end
    end
  end
end
