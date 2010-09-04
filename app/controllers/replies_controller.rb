class RepliesController < ApplicationController
  before_filter :load_parents, :only => [:names, :set_attending, :new, :index, :create, :economy, :permit]
  
  #filter_resource_access :additional_collection => {
  #  :names => :manage,
  #  :permit => :manage,
  #  :economy => :manage,
  #  :set_attending => :manage
  #}, :nested_in => :events, :shallow => true
  
  around_filter :set_locale, :only => [:new, :create, :show, :edit]
  
  def new
    @reply = @event.replies.build
    if admin_view?
      render
    else
      render_templated_action(@event.template, 'new')
    end
  end
  
  def index
    @replies = @event.replies
    respond_to do |format|
      format.html do
        if logged_in?
          render
        else
          render_templated_action(@event.template, 'index')
        end
      end
      format.js do
        
      end
    end
  end
  
  def edit
    @reply = Reply.find(params[:id])
    @event = @reply.event
    require_event_session_or_user
  end
  
  def update
    @reply = Reply.find(params[:id])
    @event = @reply.event
    
    if @reply.update_attributes(params[:reply])
      flash[:notice] = "Updated event reply"
      redirect_to(event_replies_path(@reply.event))
    else
      render :action => 'edit'
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
      params[:reply][:send_signup_confirmation] = false if params[:reply][:send_signup_confirmation].nil?
    end
    @reply = @event.replies.new(params[:reply])
    
    respond_to do |format|
      if @reply.save
        format.html do
          redirect_to(@reply)
        end
        format.xml do
          render :xml => @reply, :status => :created, :location => @reply
        end
      else
        format.html do
          render_templated_action(@event.template, 'new')
        end
        format.xml { render :xml => @reply.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @reply = Reply.find(params[:id])
    render_templated_action(@reply.event.template, 'show')
  end
  
  def economy
    if request.post?
      update_economy
    else
      @replies = @event.replies
    end
  end
  
  def permit
    @replies = @event.replies.not_cancelled.paid
  end
  
  def destroy
    @reply = Reply.find(params[:id])
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
    
    redirect_to event_replies_path(@event)
  end
  
  
  protected
  
  def admin_view?
    #(current_user || current_event_session) && 
    params[:admin_view] == "1"
  end
  helper_method :admin_view?
  
  def update_economy
    if Reply.pay(params[:reply_ids])
      redirect_to economy_event_replies_path(@event)
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
    #I18n.locale = :'sv-SE'
    yield
    #I18n.locale = :en
  end
  
  def render_templated_action(template, action)
    template_path = Rails.root + "app/templates/#{sanitize_filename(template)}.liquid"
    template = Liquid::Template.parse(File.read(template_path))
    form = render_to_string(:partial => action)
    render :text => template.render('template_content' => form)
  end
  
end
