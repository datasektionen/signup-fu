class EventRepliesController < ApplicationController
  before_filter :load_parents, :only => [:new, :index, :create, :economy]
  #skip_before_filter :verify_authenticity_token
  skip_before_filter :require_user, :only => [:new, :create, :show]
  
  before_filter :set_locale, :only => [:new, :create, :show]
  
  def new
    @reply = EventReply.new
    template_path = Rails.root + "app/templates/#{sanitize_filename(@event.template)}.liquid"
    template = Liquid::Template.parse(File.read(template_path))
    form = render_to_string(:partial => 'new')
    render :text => template.render('signup_form' => form)
  end
  
  def index
    @replies = @event.replies
  end
  
  def create
    if request.format == :xml
      params[:event_reply][:send_signup_confirmation] = false if params[:event_reply][:send_signup_confirmation].nil?
    end
    @reply = @event.replies.new(params[:event_reply])
    
    respond_to do |format|
      if @reply.save
        format.html do
          flash[:notice] = t('flash.signup_successful')
          redirect_to(@reply)
        end
        format.xml do
          render :xml => @reply, :status => :created, :location => @reply
        end
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
  
  def destroy
    @reply = EventReply.find(params[:id])
    @reply.cancel!
    flash[:notice] = "Sucessfully removed #{@reply.name}"
    redirect_to(@reply.event)
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
  
  def sanitize_filename(filename)
    filename = filename.strip
    filename.gsub!(/^.*(\\|\/)/, '')
    filename.gsub!(/[^\w\.\-]/, '_')
    filename
  end
  
  def set_locale
    I18n.locale = :'sv-SE'
  end
  
end
