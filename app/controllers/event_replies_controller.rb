class EventRepliesController < ApplicationController
  before_filter :load_parents, :only => [:new, :index, :create]
  
  def new
    @reply = EventReply.new
  end
  
  def create
    @reply = EventReply.new(params[:event_reply])
    if @reply.save
      flash[:notice] = "Your signup was successful!"
      redirect_to(@reply)
    else
      render :action => 'new'
    end
  end
  
  def show
    
  end
  
  protected
  def load_parents
    @event = Event.find(params[:event_id])
  end
end
