class EventRepliesController < ApplicationController
  before_filter :load_parents, :only => [:new, :index, :create, :economy]
  #skip_before_filter :verify_authenticity_token
  
  def new
    @reply = EventReply.new
  end
  
  def create
    
    puts params.inspect
    @reply = @event.replies.new(params[:event_reply])
    
    respond_to do |format|
      if @reply.save
        format.html do
          flash[:notice] = "Your signup was successful!"
          redirect_to(@reply)
        end
        format.xml { render :xml => @reply, :status => :created, :location => @reply }
      else
        format.html do
          render :action => 'new'  
        end
        format.xml { render :xml => @reply.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @reply = EventReply.find(params[:id])
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
