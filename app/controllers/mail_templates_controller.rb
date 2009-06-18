class MailTemplatesController < ApplicationController
  before_filter :load_parent, :only => [:new, :create]
  def new
    @mail_template = @event.mail_templates.new
  end
  
  def create
    @mail_template = @event.mail_templates.new(params[:mail_template])
    
    if @mail_template.save
      redirect_to(event_path(@event))
    else
      flash[:error] = "Error saving the template. Correct the errors than try again"
      render :action => 'new'
    end
  end
  
  private
  
  def load_parent
    @event = Event.find(params[:event_id])
  end
end
