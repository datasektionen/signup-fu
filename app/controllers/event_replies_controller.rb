class EventRepliesController < ApplicationController
  before_filter :load_parents, :only => [:names, :set_attending, :new, :index, :create, :economy]
  before_filter :require_event_session, :only => [:names, :set_attending, :index, :economy]
  skip_before_filter :require_user
  
  around_filter :set_locale, :only => [:new, :create, :show]
  
  def new
    @reply = EventReply.new
    if admin_view?
      render
    else
      render_form
    end
  end
  
  def index
    @replies = @event.replies
    respond_to do |format|
      format.html
      format.js do
        
      end
    end
  end
  
  def names
    @replies = @event.replies.not_attending
    respond_to do |format|
      format.js
    end
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
          render_form
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
  
  def set_attending
    if reply = @event.replies.find_by_name(params[:name])
      # TODO: fire both events at the same time.
      if reply.attending
        flash[:notice] = "Set #{reply.name} as attending"
        if params[:paid] && !reply.paid?
          flash[:notice] += " and paid"
          reply.pay!
        end
      else
        # TODO
        #flash[:error] = "Unable to set #{reply.name} attending: #{e.message}"
        flash[:error] = "Unable to set #{reply.name} attending."
      end
      
    else
      flash[:error] = "No such guest!"
    end
    
    redirect_to event_event_replies_path(@event)
  end
  
  
  protected
  
  def admin_view?
    (current_user || current_event_session) && params[:admin_view] == "1"
  end
  helper_method :admin_view?
  
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
    yield
    I18n.locale = :en
  end
  
  def render_form
    template_path = Rails.root + "app/templates/#{sanitize_filename(@event.template)}.liquid"
    template = Liquid::Template.parse(File.read(template_path))
    form = render_to_string(:partial => 'new')
    render :text => template.render('signup_form' => form)
  end
end
