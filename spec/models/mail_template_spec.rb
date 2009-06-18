require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MailTemplate do
  before(:each) do
    @valid_attributes = {
      :event_id => 1,
      :body => "value for body",
      :subject => "value for subject"
    }
    @template = MailTemplate.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    MailTemplate.create!(@valid_attributes)
  end
  
  it { should belong_to(:event) }
  
  describe "parsing" do
    before do
      @event = mock_model(Event, :name => 'My event')
      @reply = mock_model(EventReply, :event => @event, :name => 'Kalle', :email => "kalle@example.org")
    end
    
    %w(body subject).each do |what|
      [
        ["REPLY_NAME", "Kalle"],
        ['EVENT_NAME', 'My event']
      ].each do |variable, result|
        it "should parse {{#{variable}}} for #{what}" do
          @template.send("#{what}=", "{{#{variable}}}")
          @template.send("render_#{what}", @reply).should eql(result)
        end
      end
    end
    
    
  end
end
