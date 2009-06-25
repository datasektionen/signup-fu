class EventRepliesController < ApplicationController
  before_filter :load_parents, :only => [:new, :index, :create, :economy]
  
  def new
    @reply = EventReply.new
  end
  
  def create
    @reply = @event.replies.new(params[:event_reply])
    if @reply.save
      flash[:notice] = "Your signup was successful!"
      redirect_to(@reply)
    else
      render :action => 'new'
    end
  end
  
  def show
    
  end
  
  def economy
    if request.post?
      update_economy
    else
      @replies = @event.replies
      @time = Time.now
    end
  end
  
  
  protected
  
  def update_economy
    if EventReply.pay(params[:reply_ids])
      redirect_to economy_event_event_replies_path(@event)
    else
      render :action => 'economy'
    end
    
    
  end
  
  def load_parents
    @event = Event.find(params[:event_id])
  end
end
