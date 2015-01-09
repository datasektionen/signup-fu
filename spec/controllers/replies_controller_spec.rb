require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RepliesController do
  #before do
  #  activate_authlogic
  #end
  
  #describe "admin view" do
  #  
  #  before do
  #    @event = mock_model(Event)
  #    @event.stub(:template).and_return("default")
  #    @event.stub(:replies).and_return(double("proxy thing", :new => Reply.new))
  #    Event.stub(:find).with("1").and_return(@event)
  #  end
  #  def do_get(options = {})
  #    get :new, {:event_id => 1}.merge(options)
  #  end
  #  
  #  it "should render the event template if not logged in" do
  #    @controller.should_receive(:render_templated_action).with('default', 'new')
  #    do_get
  #  end
  #  
  #  it "should render the event template if not logged in and query param admin_view is set" do
  #    @controller.should_receive(:render_templated_action).with('default', 'new')
  #    do_get(:admin_view => 1)
  #  end
  #  
  #  it "should render the event template if logged in and viewing replies/new" do
  #    #UserSession.create(Factory(:admin))
  #    @controller.should_receive(:render_templated_action).with('default', 'new')
  #    do_get
  #  end
  #  
  #  it "should render the new view if logged in and query param admin_view is set" do
  #    #UserSession.create(Factory(:admin))
  #    @controller.should_receive(:render)
  #    do_get(:admin_view => 1)
  #  end
  #  
  #  it "should not render themplate if logged in and query param admin_view is set" do
  #    #UserSession.create(Factory(:admin))
  #    @controller.should_not_receive(:render_templated_action)
  #    do_get(:admin_view => 1)
  #  end
  #end
  
  describe "Creating replies via REST" do
    before do
      #UserSession.create(Factory(:admin))

      @valid_params = {
        :name => 'Kalle Persson',
        :email => 'kalle@example.org',
        :ticket_type_id => 1
      }
      @reply = mock_model(Reply, :save => true)
      Reply.stub(:new).and_return(@reply)
      
      @event = mock_model(Event)
      mock_association(@event, :replies, :new_object => @reply)
      Event.stub(:find).and_return(@event)
    end
    
    def mock_association(model, association, options = {})
      if options[:new_object].nil?
        new_object = mock_model(model.class.reflect_on_association(association).class_name.constantize)
        new_object.stub(:save).and_return(true)
        options[:new_object] = new_object
      end
      
      association_proxy = []
      association_proxy.stub(:new).and_return(options[:new_object])
      model.stub(association).and_return(association_proxy)
    end
    
    def do_post(reply_params = {}, params = {})
      request.accept = "text/xml"
      general_params = {:format => 'xml', :event_id => @event}.merge(params)
      post :create, {:reply => @valid_params.merge(reply_params)}.merge(general_params)
    end
    
    it "should create a reply" do
      @event.replies.should_receive(:new).and_return(@reply)
      do_post
    end
    
    it "should render the xml for the created reply" do
      @reply.stub(:to_xml).and_return("<xml><for>reply</for></xml>")
      do_post
      response.body.should eql("<xml><for>reply</for></xml>")
    end
    
    it "should default to NOT sending a confirmation mail" do
      @event.replies.should_receive(:new).with(hash_including(:send_signup_confirmation => false))
      do_post
    end
    
    it "should be possible to sending a confirmation mail" do
      @event.replies.should_receive(:new).with(hash_including(:send_signup_confirmation => 'true'))
      do_post(:send_signup_confirmation => 'true')
    end
    
  end
end
